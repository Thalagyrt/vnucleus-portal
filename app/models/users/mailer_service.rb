module Users
  class MailerService
    include ::Concerns::SimpleMailerServiceConcern

    define_mailers :login_failed, :welcome, :reset_token, :email_confirmation, :enhanced_security_token_authorization_code

    def initialize(opts = {})
      @user = opts.fetch(:user)
      @mailer = opts.fetch(:mailer) { Mailer }
    end

    private
    attr_reader :user, :mailer

    def users
      [user]
    end

    def merge_opts(user, opts)
      opts.merge(user: user)
    end
  end
end