require 'spec_helper'

describe Accounts::CreditService do
  let(:account) { double(:account, balance_favorable?: false) }
  let(:automation_service) { double(:automation_service) }
  let(:batch) { double(:batch) }
  let(:batch_transaction_service) { double(:batch_transaction_service) }
  subject { described_class.new(account: account, automation_service: automation_service, batch_transaction_service: batch_transaction_service) }

  before { allow(batch_transaction_service).to receive(:batch).and_yield(batch) }
  before { allow(batch).to receive(:add_credit) }

  describe "#add_credit" do
    it "adds a credit to the account" do
      expect(batch).to receive(:add_credit).with(500, "Test")

      subject.add_credit(500, "Test")
    end

    context "when the account's balance becomes favorable" do
      before { allow(account).to receive(:balance_favorable?).and_return(true) }

      it "marks the account as in favor" do
        expect(automation_service).to receive(:in_favor)

        subject.add_credit(500, "Test")
      end
    end
  end
end