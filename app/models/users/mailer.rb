module Users
  class Mailer < ActionMailer::Base
    default from: '"vNucleus" <noreply@vnucleus.com>'

    def login_failed(opts)
      @user = opts.fetch(:user)
      @ip_address = opts.fetch(:ip_address)

      mail(to: @user.email, subject: "Failed login from #{@ip_address}")
    end

    def welcome(opts)
      @user = opts.fetch(:user)

      mail(to: @user.email, subject: 'Welcome to vNucleus!')
    end

    def reset_token(opts)
      @user = opts.fetch(:user)

      mail(to: @user.email, subject: "Password reset instructions.").tap do |message|
        message["X-vNucleus-No-Log-Body"] = true
      end
    end

    def email_confirmation(opts)
      @user = opts.fetch(:user)

      mail(to: @user.email, subject: "Please confirm your email.").tap do |message|
        message["X-vNucleus-No-Log-Body"] = true
      end
    end

    def enhanced_security_token_authorization_code(opts)
      @user = opts.fetch(:user)
      @enhanced_security_token = opts.fetch(:enhanced_security_token)

      mail(to: @user.email, subject: "Your authorization code.").tap do |mesage|
        message["X-vNucleus-No-Log-Body"] = true
      end
    end

    def invite(opts)
      @invite = opts.fetch(:invite).decorate

      mail(to: @invite.email, subject: "You've been invited to join account #{@invite.account.to_s}.").tap do |message|
        message["X-vNucleus-No-Log-Body"] = true
      end
    end
  end
end