require 'spec_helper'

describe Accounts::StripeCardService do
  let(:account) { double :account }
  let(:stripe_customer) { double :stripe_customer }
  let(:stripe_customer_service) { double :stripe_customer_service, stripe_customer: stripe_customer }
  subject { described_class.new(account: account, stripe_customer_service: stripe_customer_service) }

  describe "#delete" do
    let(:card) { double :card }
    before { allow(stripe_customer).to receive(:cards).and_return([card]) }
    before { allow(account).to receive(:update_attributes) }
    before { allow(card).to receive(:delete) }

    it "removes the cards" do
      expect(card).to receive(:delete)

      subject.delete
    end

    it "updates the account's stripe data" do
      expect(account).to receive(:update_attributes).with hash_including(stripe_valid: false, stripe_expiration_date: nil)

      subject.delete
    end
  end
end