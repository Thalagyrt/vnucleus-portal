module Accounts
  class AccountCreator
    include Wisper::Publisher

    def initialize(opts)
      @user = opts.fetch(:user)
      @request = opts.fetch(:request)
      @account_factory = opts.fetch(:account_factory) { Account }
      @credit_card_updater_class = opts.fetch(:credit_card_updater_class) { CreditCardUpdater }
      @stripe_customer_service_class = opts.fetch(:stripe_customer_service_class) { StripeCustomerService }
    end

    def create(params)
      @account_form = Accounts::AccountForm.new(params)

      if account_form.valid?
        account_factory.transaction do
          @account = account_factory.new(account_form.account_params)

          schedule_affiliate_payout
          persist_account
          update_credit_card

          Rails.logger.info { "Created new account #{account}" }

          return publish(:create_success, account)
        end
      end

      publish(:create_failure, account_form)
    end

    private
    attr_reader :user, :account, :account_factory, :request, :account_form, :credit_card_updater_class, :account_activation_service_class, :stripe_customer_service_class
    delegate :stripe_customer, to: :stripe_customer_service

    def persist_account
      account.save!
      account.memberships.create!(user: user, roles: [:full_control])
    end

    def update_credit_card
      credit_card_updater.on(:update_failure) do |credit_card|
        credit_card.errors[:number].each do |value|
          account_form.errors[:credit_card_number] << value
        end

        stripe_customer.delete

        raise ActiveRecord::Rollback
      end

      credit_card_updater.update(account_form.credit_card_params)
    end

    def schedule_affiliate_payout
      if account.referrer.present?
        account.pay_referrer_at = Time.zone.today + affiliate_period
      end
    end

    def affiliate_period
      Rails.application.config.affiliate_payout_period
    end

    def credit_card_updater
      @credit_card_updater ||= credit_card_updater_class.new(account: account, user: user, request: request)
    end

    def stripe_customer_service
      @stripe_customer_service ||= stripe_customer_service_class.new(account: account)
    end
  end
end