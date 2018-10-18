module Users
  module Sessions
    class OneTimePasswordValidator
      include Wisper::Publisher

      def initialize(opts = {})
        @user = opts.fetch(:user)
      end

      def validate(params)
        @one_time_password_session_form = OneTimePasswordForm.new(params)

        if one_time_password_session_form.valid?
          if rotp.verify_with_drift(one_time_password_session_form.otp, 30)
            return publish(:validate_success)
          end

          one_time_password_session_form.errors[:otp] << :invalid
        end

        publish(:validate_failure, one_time_password_session_form)
      end

      private
      attr_reader :user, :request, :one_time_password_session_form

      def rotp
        @rotp ||= ROTP::TOTP.new(user.otp_secret)
      end
    end
  end
end