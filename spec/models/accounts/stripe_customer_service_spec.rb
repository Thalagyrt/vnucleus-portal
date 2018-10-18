require 'spec_helper'

describe Accounts::StripeCustomerService do
  let(:account) { double(:account, id: 1, long_id: 'xyzpdq') }
  let(:customer) { double(:customer, id: 'cus_123') }
  subject { described_class.new(account: account) }

  describe "#stripe_customer" do
    context "when the account has a valid stripe customer" do
      before { allow(account).to receive(:stripe_id).and_return('cus_123') }
      before { allow(Stripe::Customer).to receive(:retrieve).with(account.stripe_id).and_return(customer) }

      it "retrieves the customer" do
        expect(Stripe::Customer).to receive(:retrieve).with(account.stripe_id)

        subject.stripe_customer
      end

      it "returns the retrieved stripe customer" do
        expect(subject.stripe_customer).to be(customer)
      end
    end

    context "when the stripe customer id is invalid" do
      before { allow(account).to receive(:stripe_id).and_return('cus_123') }
      before { allow(Stripe::Customer).to receive(:retrieve).with(account.stripe_id).and_raise(Stripe::InvalidRequestError.new(:test, :test)) }
      before { allow(Stripe::Customer).to receive(:create).and_return(customer) }
      before { allow(account).to receive(:update_attribute) }

      it "creates a new customer" do
        expect(Stripe::Customer).to receive(:create)

        subject.stripe_customer
      end

      it "updates the account's stripe_id" do
        expect(account).to receive(:update_attribute).with(:stripe_id, customer.id)

        subject.stripe_customer
      end

      it "returns the retrieved stripe customer" do
        expect(subject.stripe_customer).to be(customer)
      end
    end

    context "when the account doesn't have a stripe customer id" do
      before { allow(account).to receive(:stripe_id).and_return(nil) }
      before { allow(Stripe::Customer).to receive(:retrieve).with(account.stripe_id).and_raise(Stripe::InvalidRequestError.new(:test, :test)) }
      before { allow(Stripe::Customer).to receive(:create).and_return(customer) }
      before { allow(account).to receive(:update_attribute) }

      it "creates a new customer" do
        expect(Stripe::Customer).to receive(:create)

        subject.stripe_customer
      end

      it "updates the account's stripe_id" do
        expect(account).to receive(:update_attribute).with(:stripe_id, customer.id)

        subject.stripe_customer
      end

      it "returns the retrieved stripe customer" do
        expect(subject.stripe_customer).to be(customer)
      end
    end
  end
end