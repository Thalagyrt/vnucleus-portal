module Users
  class AuthenticationFailureMailerPolicy
    attr_reader :user

    def initialize(opts = {})
      @user = opts.fetch(:user)
    end

    def mailer
      if user.is_staff?
        ::Admin::MailerService.new
      else
        ::Users::MailerService.new(user: user)
      end
    end
  end
end