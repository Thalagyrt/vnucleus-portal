module Admin
  class MailerService
    include Concerns::SimpleMailerServiceConcern

    define_mailers :ticket_created, :ticket_updated, :server_confirmed, :server_terminated,
                   :provision_stalled, :login_failed, :account_pending_activation, :lead_captured

    def initialize(opts = {})
      @mailer = opts.fetch(:mailer) { Mailer }
    end

    private
    attr_accessor :mailer

    def users
      @users ||= ::Users::User.staff
    end

    def merge_opts(user, opts = {})
      opts.merge(user: user)
    end
  end
end