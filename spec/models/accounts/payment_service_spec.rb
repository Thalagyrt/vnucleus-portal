require 'spec_helper'

describe Accounts::PaymentService do
  let(:account) { create(:account, stripe_id: 'cus_123') }
  let(:mailer_service) { double(:mailer_service) }
  let(:event_logger) { double(:event_logger) }
  let(:automation_service) { double(:automation_service) }

  subject do
    described_class.new(
        account: account,
        mailer_service: mailer_service,
        event_logger: event_logger,
        automation_service: automation_service
    )
  end

  before { allow(event_logger).to receive(:log) }
  before { allow(event_logger).to receive(:with_entity).and_return(event_logger) }
  before { allow(automation_service).to receive(:in_favor) }

  describe "#charge_balance" do
    context "when the account's balance is not favorable" do
      let(:card) { double(:card, last4: '4242', type: 'Visa').as_null_object }
      let(:charge) { double(:charge, id: 'ch_123', amount: 995, card: card, fee: 45) }

      before { create :transaction, account: account, amount: 995 }
      before { allow(Stripe::Charge).to receive(:create).and_return(charge) }
      before { allow(mailer_service).to receive(:payment_received) }

      it "adds a payment to the account" do
        expect { subject.charge_balance }.to change { account.balance }.by(-995)
      end

      it "marks the account in favor" do
        expect(automation_service).to receive(:in_favor)

        subject.charge_balance
      end

      it "returns true" do
        expect(subject.charge_balance).to be_truthy
      end
    end
  end

  describe "#charge" do
    context "when the payment is successfully captured" do
      let(:card) { double(:card, last4: '4242', type: 'Visa').as_null_object }
      let(:charge) { double(:charge, id: 'ch_123', amount: 500, card: card, fee: 45) }

      before { allow(Stripe::Charge).to receive(:create).and_return(charge) }
      before { allow(mailer_service).to receive(:payment_received) }
      before { allow(automation_service).to receive(:in_favor) }

      it "adds a payment to the account" do
        expect(account).to receive(:add_payment).with(charge.amount, charge.fee, instance_of(Accounts::CreditCard), charge.id)

        subject.charge(charge.amount)
      end

      it "sends a thank you email" do
        expect(mailer_service).to receive(:payment_received)

        subject.charge(charge.amount)
      end

      it "returns true" do
        expect(subject.charge(charge.amount)).to be_truthy
      end

      it "logs an account event" do
        expect(event_logger).to receive(:log).with(:payment_received)

        subject.charge(charge.amount)
      end

      context "when the resulting balance is favorable" do
        it "marks the account in favor" do
          expect(automation_service).to receive(:in_favor)

          subject.charge(charge.amount)
        end
      end

      context "when the resulting balance is not favorable" do
        before { create :transaction, account: account, amount: 995 }

        it "marks the account in favor" do
          expect(automation_service).to_not receive(:in_favor)

          subject.charge(charge.amount)
        end
      end
    end

    context "when the payment fails" do
      before { allow(Stripe::Charge).to receive(:create).and_raise(Stripe::CardError.new(1, 2, 3)) }
      before { allow(mailer_service).to receive(:payment_failed) }

      it "sends a failure email" do
        expect(mailer_service).to receive(:payment_failed)

        subject.charge(500)
      end

      it "returns false" do
        expect(subject.charge(500)).to be_falsey
      end
    end

    context "when the account doesn't have a customer id" do
      before { allow(account).to receive(:stripe_id).and_return(nil) }
      before { allow(mailer_service).to receive(:payment_failed) }

      it "sends a failure email" do
        expect(mailer_service).to receive(:payment_failed)

        subject.charge(500)
      end

      it "returns false" do
        expect(subject.charge(500)).to be_falsey
      end
    end
  end
end