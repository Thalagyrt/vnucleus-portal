module Users
  module Sessions
    class UserAuthenticator
      include Wisper::Publisher

      def initialize(opts = {})
        @request = opts.fetch(:request)
        @mailer_policy_class = opts.fetch(:mailer_policy_class) { ::Users::AuthenticationFailureMailerPolicy }
        @event_logger_class = opts.fetch(:event_logger_class) { ::Users::EventLogger }
      end

      def authenticate(params)
        session_form = SessionForm.new(params)

        log_data = session_form.email

        if session_form.valid?
          @user = User.find_by_email(session_form.email)

          if user.present?
            log_data = "#{user.email} (#{user.id})"

            if user.authenticate(session_form.password)
              Rails.logger.info { "Successful login for #{log_data}" }

              event_logger.log("Logged in.")
              return publish(:authentication_success, user)
            else
              event_logger.log("Failed login attempt.")
              mailer.login_failed(failed_user: user, ip_address: remote_ip)
            end
          end

          session_form.errors[:email] << 'invalid credentials'
        end

        Rails.logger.info { "Failed login for #{log_data}" }

        publish(:authentication_failure, session_form)
      end

      private
      attr_reader :user, :request, :mailer_policy_class, :event_logger_class
      delegate :remote_ip, to: :request
      delegate :mailer, to: :mailer_policy

      def event_logger
        @event_logger ||= event_logger_class.new(user: user, category: :access, ip_address: remote_ip)
      end

      def mailer_policy
        @mailer_policy ||= mailer_policy_class.new(user: user)
      end
    end
  end
end