require 'spec_helper'

describe Accounts::CreditCardExpirationTask do
  subject { described_class.new }
  let!(:account) { create :account }

  context "when an account has an expiring credit card" do
    before { account.update_attribute :stripe_expiration_date, Time.zone.today + 1.day }

    it "enqueues a task for the account" do
      expect(Delayed::Job).to receive(:enqueue).with(instance_of(Accounts::CreditCardExpirationJob))

      subject.perform
    end

    context "when the account is pending billing information" do
      before { account.update_attributes state: :pending_billing_information }

      it "does not enqueue a task for the account" do
        expect(Delayed::Job).to_not receive(:enqueue).with(instance_of(Accounts::CreditCardExpirationJob))

        subject.perform
      end
    end

    context "when the account is pending activation" do
      before { account.update_attributes state: :pending_activation }

      it "does not enqueue a task for the account" do
        expect(Delayed::Job).to_not receive(:enqueue).with(instance_of(Accounts::CreditCardExpirationJob))

        subject.perform
      end
    end

    context "when the account is rejected" do
      before { account.update_attributes state: :rejected }

      it "does not enqueue a task for the account" do
        expect(Delayed::Job).to_not receive(:enqueue).with(instance_of(Accounts::CreditCardExpirationJob))

        subject.perform
      end
    end
  end

  context "when an account has an expired credit card" do
    before { account.update_attribute :stripe_expiration_date, Time.zone.today - 1.month }

    it "does not enqueue a task for the account" do
      expect(Delayed::Job).to_not receive(:enqueue).with(instance_of(Accounts::CreditCardExpirationJob))

      subject.perform
    end
  end

  context "when an account doesn't have an expiring credit card" do
    before { account.update_attribute :stripe_expiration_date, Time.zone.today + 1.year }

    it "does not enqueue a task for the account" do
      expect(Delayed::Job).to_not receive(:enqueue).with(instance_of(Accounts::CreditCardExpirationJob))

      subject.perform
    end
  end
end