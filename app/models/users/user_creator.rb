module Users
  class UserCreator
    include Wisper::Publisher

    def initialize(opts = {})
      @user_factory = opts.fetch(:user_factory) { User }
      @mailer_service_class = opts.fetch(:mailer_service_class) { MailerService }
      @request = opts.fetch(:request)
      @enhanced_security_token = opts.fetch(:enhanced_security_token)
    end

    def create(params)
      @user_form = UserForm.new(params)

      if user_form.valid?
        @user = user_factory.new(user_form.user_params)

        if user.save
          user.enhanced_security_tokens.create(token: enhanced_security_token, last_seen_ip_address: request.remote_ip, authorized: true)

          mailer_service.welcome
          mailer_service.email_confirmation

          Rails.logger.info { "Created new user #{user}" }

          return publish(:create_success, @user)
        end
      end

      publish :create_failure, @user_form
    end

    private
    attr_reader :user, :user_form, :user_factory, :mailer_service_class, :request, :enhanced_security_token

    def mailer_service
      @mailer_service ||= mailer_service_class.new(user: user)
    end
  end
end