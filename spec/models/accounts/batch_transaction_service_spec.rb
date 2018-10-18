require 'spec_helper'

describe Accounts::BatchTransactionService do
  let(:account) { double(:account) }
  let(:account_mailer_service) { double(:account_mailer_service) }
  subject { described_class.new(account: account, mailer_service: account_mailer_service) }

  before { allow(account).to receive(:add_debit) }
  before { allow(account).to receive(:add_credit) }
  before { allow(account).to receive(:add_referral) }
  before { allow(account_mailer_service).to receive(:transactions_posted) }
  before { allow(account).to receive(:with_lock) {|&b| b.call} }

  describe "#batch" do
    it "sends a summation of transactions" do
      expect(account_mailer_service).to receive(:transactions_posted)

      subject.batch do |batch|
        batch.add_debit(500, 'test')
      end
    end

    it "adds debits to the account" do
      expect(account).to receive(:add_debit).with(500, 'test')

      subject.batch do |batch|
        batch.add_debit(500, 'test')
      end
    end

    it "adds referrals to the account" do
      expect(account).to receive(:add_referral).with(500, 'test')

      subject.batch do |batch|
        batch.add_referral(500, 'test')
      end
    end

    it "adds credits to the account" do
      expect(account).to receive(:add_credit).with(500, 'test')

      subject.batch do |batch|
        batch.add_credit(500, 'test')
      end
    end
  end
end