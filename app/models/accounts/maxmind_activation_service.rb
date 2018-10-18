module Accounts
  class MaxmindActivationService
    def initialize(opts = {})
      @account = opts.fetch(:account)
      @user = opts.fetch(:user)
      @request = opts.fetch(:request)
      @license_key = opts.fetch(:license_key) { ::Rails.application.config.maxmind_license_key }
      @activation_threshold = opts.fetch(:activation_threshold) { ::Rails.application.config.maxmind_threshold }
      @event_logger = opts.fetch(:event_logger) { EventLogger.new(account: account) }
      @admin_mailer_service = opts.fetch(:admin_mailer_service) { ::Admin::MailerService.new }
      @admin_notification_service = opts.fetch(:admin_notification_service) { ::Admin::NotificationService.new }
    end

    def activate
      response = Maxmind::Api::Request.new(license_key, options).response

      store_response(response)

      Rails.logger.info { "Risk score: #{response.risk_score}"}

      if response.risk_score <= activation_threshold
        activate_account
      else
        manual_activation
      end
    end

    private
    attr_reader :account, :user, :request, :license_key, :activation_threshold, :event_logger, :admin_mailer_service, :admin_notification_service

    def activate_account
      Rails.logger.info { "Activating account #{account}"}

      account.activate!

      event_logger.with_category(:event).log(:account_activated)
    end

    def manual_activation
      Rails.logger.info { "Account #{account} requires manual activation"}

      admin_mailer_service.account_pending_activation(account: account)
      admin_notification_service.account_pending_activation(target: account)
    end

    def store_response(response)
      account.update_attribute :maxmind_response, response.as_hash
    end

    def options
      {
          client_ip: request.remote_ip,
          city: account.address_city,
          state: account.address_state,
          zip: account.address_zip,
          country: account.address_country,
          email: user.email,
          phone: user.phone,
      }
    end
  end
end