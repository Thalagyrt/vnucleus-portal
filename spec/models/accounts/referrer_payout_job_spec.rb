require 'spec_helper'

describe Accounts::ReferrerPayoutJob do
  let(:referrer) { double :account, affiliate_enabled?: true }
  let(:account) { double :account, referrer: referrer, monthly_rate: 0, long_id: 'testy' }
  let(:batch_transaction_service) { double :batch_transaction_service }
  let(:batch) { double(:batch) }

  before { allow(account).to receive(:with_lock) { |&b| b.call } }
  before { allow(account).to receive(:update_attributes) }
  before { allow(batch_transaction_service).to receive(:batch).and_yield(batch) }

  subject { described_class.new(account: account, batch_transaction_service: batch_transaction_service) }

  context "when the referrer has affiliate enabled" do
    context "when the account has a current run rate" do
      before { allow(account).to receive(:monthly_rate).and_return(2000) }
      before { allow(referrer).to receive(:add_referral) }

      it "adds a referral to the batch" do
        expect(batch).to receive(:add_referral).with(2000, anything)

        subject.perform
      end
    end

    context "when the does not have a current run rate" do
      before { allow(account).to receive(:monthly_rate).and_return(0) }
      before { allow(referrer).to receive(:add_referral) }

      it "does not add a referral to the batch" do
        expect(batch).to_not receive(:add_referral)

        subject.perform
      end
    end
  end

  context "when the referrer has affiliate disabled" do
    before { allow(referrer).to receive(:affiliate_enabled?).and_return(false) }

    context "when the account has a current run rate" do
      before { allow(account).to receive(:monthly_rate).and_return(2000) }
      before { allow(referrer).to receive(:add_referral) }

      it "does not add a referral to the batch" do
        expect(batch).to_not receive(:add_referral)

        subject.perform
      end
    end

    context "when the does not have a current run rate" do
      before { allow(account).to receive(:monthly_rate).and_return(0) }
      before { allow(referrer).to receive(:add_referral) }

      it "does not add a referral to the batch" do
        expect(batch).to_not receive(:add_referral)

        subject.perform
      end
    end
  end

  it "unsets the referrer pay date" do
    expect(account).to receive(:update_attributes).with hash_including(pay_referrer_at: nil)

    subject.perform
  end
end