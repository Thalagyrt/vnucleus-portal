module Accounts
  class StripeCustomerService
    def initialize(opts = {})
      @account = opts.fetch(:account)
    end

    def stripe_customer
      @stripe_customer ||= fetch_customer
    end

    private
    attr_reader :account

    def fetch_customer
      return create_customer unless stripe_customer_id

      retrieve_customer
    rescue ::Stripe::InvalidRequestError => e
      Airbrake.notify_or_ignore(e)

      create_customer
    end

    def retrieve_customer
      ::Stripe::Customer.retrieve(stripe_customer_id)
    end

    def create_customer
      Rails.logger.info { "Creating stripe customer for account #{account}" }

      ::Stripe::Customer.create(description: "Account ##{@account.to_param}").tap do |customer|
        Rails.logger.info { "Stripe customer created. id: #{customer.id}" }

        account.update_attribute(:stripe_id, customer.id)
      end
    end

    def stripe_customer_id
      account.stripe_id
    end
  end
end