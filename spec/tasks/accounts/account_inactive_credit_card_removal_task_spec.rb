require 'spec_helper'

describe Accounts::InactiveCreditCardRemovalTask do
  subject { described_class.new }
  let!(:account) { create :account }

  context "when the account's credit card is older than the removal period" do
    before { account.update_attribute :credit_card_updated_at, Rails.application.config.credit_card_removal_period.ago - 1.day }

    it "enqueues a task for the account" do
      expect(Delayed::Job).to receive(:enqueue).with(instance_of(Accounts::CreditCardRemovalJob))

      subject.perform
    end

    context "when an account has an active server" do
      before { create :solus_server, account: account, state: :active }

      it "does not enqueue a task for the account" do
        expect(Delayed::Job).to_not receive(:enqueue).with(instance_of(Accounts::CreditCardRemovalJob))

        subject.perform
      end
    end

    context "when an account has an active license" do
      before { create :license, account: account, count: 1 }

      it "does not enqueue a task for the account" do
        expect(Delayed::Job).to_not receive(:enqueue).with(instance_of(Accounts::CreditCardRemovalJob))

        subject.perform
      end
    end
  end

  context "when an account has no billing information on file" do
    before { account.update_attribute :stripe_id, nil }

    it "does not enqueue a task for the account" do
      expect(Delayed::Job).to_not receive(:enqueue).with(instance_of(Accounts::CreditCardRemovalJob))

      subject.perform
    end
  end

  context "when an account has an expired credit card" do
    before { account.update_attribute :stripe_expiration_date, Time.zone.today - 1.month }

    it "does not enqueue a task for the account" do
      expect(Delayed::Job).to_not receive(:enqueue).with(instance_of(Accounts::CreditCardRemovalJob))

      subject.perform
    end
  end
end