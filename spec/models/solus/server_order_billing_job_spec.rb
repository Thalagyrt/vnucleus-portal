require 'spec_helper'

describe Solus::ServerOrderBillingJob do
  let(:account) { double(:account) }
  let(:server) { double(:server, id: 1, account: account, amount: 995, prorated_amount: 250, description: 'Server #1 (testy)', next_due: Time.zone.today + 1.month) }
  let(:server_payment_job) { double(:server_payment_job) }
  let(:batch_transaction_service) { double(:batch_transaction_service) }
  let(:automation_service) { double(:automation_service) }
  let(:payment_service) { double(:payment_service) }
  let(:event_logger) { double(:event_logger) }

  subject do
    described_class.new(
        server: server,
        batch_transaction_service: batch_transaction_service,
        automation_service: automation_service,
        payment_service: payment_service,
        event_logger: event_logger
    )
  end

  before { allow(server).to receive(:with_lock) { |&b| b.call } }

  context "when the server is pending billing" do
    let(:batch) { double(:batch) }

    before { allow(event_logger).to receive(:log) }
    before { allow(server).to receive(:billed).and_return(true) }
    before { allow(server).to receive(:pending_billing?).and_return(true) }
    before { allow(batch_transaction_service).to receive(:batch).and_yield(batch) }
    before { allow(automation_service).to receive(:in_favor) }
    before { allow(payment_service).to receive(:charge_balance) }
    before { allow(account).to receive(:balance_favorable?).and_return(false) }
    before { allow(batch).to receive(:add_debit) }

    it "adds a debit to the account ledger" do
      expect(batch).to receive(:add_debit).with(250, anything)

      subject.perform
    end

    context "when the account's balance is unfavorable" do
      before { allow(account).to receive(:balance_favorable?).and_return(false) }

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

    it "marks the server billed" do
      expect(server).to receive(:billed)

      subject.perform
    end

    it "logs an account event" do
      expect(event_logger).to receive(:log).with(:server_billed)

      subject.perform
    end
  end

  context "when the server is not pending billing" do
    before { allow(server).to receive(:pending_billing?).and_return(false) }

    it "raises an exception" do
      expect { subject.perform }.to raise_error(AbortDelayedJob)
    end
  end

  it "only allows two attempts" do
    expect(subject.max_attempts).to eq(2)
  end
end