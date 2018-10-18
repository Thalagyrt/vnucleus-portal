require 'spec_helper'

describe Accounts::BillingTask do
  subject { described_class.new }
  let!(:account) { create :account }

  context "when the account is active" do
    before { account.update_attributes state: :active }

    it "enqueues a task for the account" do
      expect(Delayed::Job).to receive(:enqueue).with(instance_of(Accounts::BillingJob))

      subject.perform
    end
  end

  context "when the account is pending activation" do
    before { account.update_attributes state: :pending_activation }

    it "does not enqueue a task for the account" do
      expect(Delayed::Job).to_not receive(:enqueue).with(instance_of(Accounts::BillingJob))

      subject.perform
    end
  end

  context "when the account is pending billing information" do
    before { account.update_attributes state: :pending_billing_information }

    it "does not enqueue a task for the account" do
      expect(Delayed::Job).to_not receive(:enqueue).with(instance_of(Accounts::BillingJob))

      subject.perform
    end
  end

  context "when the account is closed" do
    before { account.update_attributes state: :closed }

    it "does not enqueue a task for the account" do
      expect(Delayed::Job).to_not receive(:enqueue).with(instance_of(Accounts::BillingJob))

      subject.perform
    end
  end

  context "when the account is rejected" do
    before { account.update_attributes state: :rejected }

    it "does not enqueue a task for the account" do
      expect(Delayed::Job).to_not receive(:enqueue).with(instance_of(Accounts::BillingJob))

      subject.perform
    end
  end
end