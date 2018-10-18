module Accounts
  class NotificationService
    include ::Concerns::SimpleNotificationServiceConcern


    def initialize(opts = {})
      @account = opts.fetch(:account)
    end

    define_notifiers :ticket_created, :ticket_updated

    define_notifiers :server_confirmed, :server_provisioned, :server_terminated do |power|
      power.account_solus_servers?(account)
    end

    private
    attr_reader :account
    delegate :users, to: :account

    def link_policy
      'users'
    end
  end
end