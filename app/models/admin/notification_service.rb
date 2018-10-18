module Admin
  class NotificationService
    include ::Concerns::SimpleNotificationServiceConcern

    define_notifiers :ticket_created, :ticket_updated, :account_pending_activation, :server_confirmed, :server_terminated

    private
    def users
      @users ||= ::Users::User.staff
    end

    def link_policy
      'admin'
    end
  end
end