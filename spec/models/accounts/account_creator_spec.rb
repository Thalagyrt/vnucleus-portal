require 'spec_helper'

class FailingCreditCardUpdater
  include Wisper::Publisher

  def initialize(_)

  end

  def update(_)
    publish(:update_failure, CreditCard.new)
  end

  class CreditCard
    def errors
      {
          number: ['invalid']
      }
    end
  end
end

class PassingCreditCardUpdater
  include Wisper::Publisher

  def initialize(_)

  end

  def update(_)
    publish(:update_success)
  end
end

describe Accounts::AccountCreator do
  let(:user) { create :user }
  let(:stripe_customer_service_class) { double(:stripe_customer_service_class) }
  let(:stripe_customer) { double(:stripe_customer) }
  let(:stripe_customer_service) { double(:stripe_customer_service, stripe_customer: stripe_customer) }
  subject { described_class.new(user: user, request: request, credit_card_updater_class: credit_card_updater_class, stripe_customer_service_class: stripe_customer_service_class) }

  before { allow(stripe_customer_service_class).to receive(:new).and_return(stripe_customer_service) }

  describe "#create" do
    context "with valid data" do
      let(:request) { double(:request, remote_ip: '127.0.0.1') }

      let(:credit_card_updater_class) { PassingCreditCardUpdater }

      let(:account_form_params) do
        {
            account_entity_name: 'Derpy', credit_card_token: 'tok_123', credit_card_name: 'Derpy Bogsworth',
            credit_card_address_line1: '123 Hayden Lane', credit_card_address_city: 'Derpsville',
            credit_card_address_state: 'Florida', credit_card_address_zip: '31337',
            credit_card_address_country: 'United States of America'
        }
      end

      context "when the credit card updater fails" do
        let(:credit_card_updater_class) { FailingCreditCardUpdater }
        before { allow(stripe_customer).to receive(:delete) }

        it "fails" do
          expect { subject.create(account_form_params) }.to publish_event(subject, :create_failure)
        end

        it "deletes the stripe customer" do
          expect { stripe_customer.to receive(:delete) }

          subject.create(account_form_params)
        end
      end
    end
  end
end