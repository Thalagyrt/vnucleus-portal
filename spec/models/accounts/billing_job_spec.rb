require 'spec_helper'

describe Accounts::BillingJob do
  let(:account) { create(:account) }
  let(:batch_transaction_service) { double(:batch_transaction_service) }
  let(:automation_service) { double(:automation_service) }
  let(:payment_service) { double(:payment_service) }
  let(:event_logger) { double(:event_logger) }
  let(:batch) { double(:batch) }

  subject do
    described_class.new(
        account: account,
        batch_transaction_service: batch_transaction_service,
        automation_service: automation_service,
        payment_service: payment_service,
        event_logger: event_logger
    )
  end

  before { allow(event_logger).to receive(:with_entity).and_return(event_logger) }
  before { allow(event_logger).to receive(:log) }
  before { allow(automation_service).to receive(:out_of_favor) }
  before { allow(automation_service).to receive(:in_favor) }
  before { allow(batch_transaction_service).to receive(:batch).and_yield(batch) }
  before { allow(batch).to receive(:add_debit).and_return(true) }
  before { allow(batch).to receive(:add_referral).and_return(true) }
  before { allow(payment_service).to receive(:charge_balance) }

  context "with a solus server" do
    let!(:server) { create(:solus_server, account: account, state: :active, amount: 995, next_due: Time.zone.today) }

    it "adds a debit to the account" do
      expect(batch).to receive(:add_debit).with(server.amount, anything)

      subject.perform
    end

    it "updates the server's billing date" do
      expect { subject.perform }.to change { server.reload.next_due }.to(server.send(:new_next_due))
    end

    context "when the server has a bandwidth overage" do
      let(:overage) { 10.gigabytes }
      let(:transfer_overage_amount) { Rails.application.config.transfer_overage_amount }

      before { server.update_attribute :used_transfer, server.transfer + overage }

      it "adds a debit to the account" do
        expect(batch).to receive(:add_debit).with(overage / 1.gigabyte * transfer_overage_amount, anything)

        subject.perform
      end
    end

    it "adds a log entry for each server" do
      expect(event_logger).to receive(:log).with(:server_billed)

      subject.perform
    end
  end

  context "with a dedicated server" do
    let!(:server) { create(:dedicated_server, account: account, state: :active, amount: 995, next_due: Time.zone.today) }

    it "adds a debit to the account" do
      expect(batch).to receive(:add_debit).with(server.amount, anything)

      subject.perform
    end

    it "updates the server's billing date" do
      expect { subject.perform }.to change { server.reload.next_due }.to(server.send(:new_next_due))
    end

    it "adds a log entry for each server" do
      expect(event_logger).to receive(:log).with(:server_billed)

      subject.perform
    end
  end

  context "with a license" do
    let!(:license) { create(:license, account: account, next_due: Time.zone.today) }

    it "adds a debit to the account" do
      expect(batch).to receive(:add_debit).with(license.amount * license.count, anything)

      subject.perform
    end

    it "updates the license's billing date" do
      expect { subject.perform }.to change { license.reload.next_due }.to(license.send(:new_next_due))
    end
  end

  context "when the account's global services are not due" do
    before { account.update_attributes next_due: Time.zone.today + 1.day }

    it "does not push the account's due date" do
      expect { subject.perform }.to_not change { account.reload.next_due }
    end

    context "when the account has affiliate enabled" do
      before { account.update_attributes affiliate_enabled: true }

      let(:referred_account) { create :account, referrer: account }
      let!(:referred_server) { create(:solus_server, account: referred_account, state: :active, amount: 995, next_due: Time.zone.today) }

      it "does not credit referrals" do
        expect(batch).to_not receive(:add_referral)

        subject.perform
      end
    end
  end

  context "when the account's global services are due" do
    before { account.update next_due: Time.zone.today }

    it "updates the account's billing date" do
      expect { subject.perform }.to change { account.reload.next_due }.to(account.send(:new_next_due))
    end

    context "when the account has affiliate enabled" do
      before { account.update_attributes affiliate_enabled: true }

      let(:referred_account) { create :account, referrer: account }
      let!(:referred_server) { create(:solus_server, account: referred_account, state: :active, amount: 995, next_due: Time.zone.today) }
      let(:affiliate_recurring_factor) { Rails.application.config.affiliate_recurring_factor }

      it "adds a referral to the batch" do
        expect(batch).to receive(:add_referral).with(referred_server.amount * affiliate_recurring_factor, anything)

        subject.perform
      end
    end
  end

  context "when the account's global services are not due" do
    before { account.update next_due: Time.zone.today + 1.day }

    it "does not update the account's billing date" do
      expect { subject.perform }.to_not change { account.reload.next_due }
    end
  end

  context "when the account's balance is unfavorable" do
    before { allow(account).to receive(:balance_favorable?).and_return(false) }

    it "marks the account out of favor" do
      expect(automation_service).to receive(:out_of_favor)

      subject.perform
    end

    it "charges the account's balance" do
      expect(payment_service).to receive(:charge_balance)

      subject.perform
    end
  end

  context "when the account's balance is favorable" do
    before { allow(account).to receive(:balance_favorable?).and_return(true) }

    it "marks the account out of favor" do
      expect(automation_service).to receive(:in_favor)

      subject.perform
    end
  end

  context "when the account is due for closure" do
    before { account.update_attributes close_on: Time.zone.today }

    it "closes the account" do
      expect(automation_service).to receive(:close_account)

      subject.perform
    end
  end

  it "only allows one attempt" do
    expect(subject.max_attempts).to eq(1)
  end
end