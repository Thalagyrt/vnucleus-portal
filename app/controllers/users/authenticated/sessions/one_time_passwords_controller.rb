module Users
  module Authenticated
    module Sessions
      class OneTimePasswordsController < Users::Authenticated::Sessions::ApplicationController
        def new
          @one_time_password_session_form = ::Users::Sessions::OneTimePasswordForm.new
        end

        def create
          one_time_password_validator.on(:validate_success) do
            self.otp_verified = true
            flash[:notice] = "Welcome back, #{current_user.first_name}!"
            redirect_logged_in_user
          end

          one_time_password_validator.on(:validate_failure) do |one_time_password_session_form|
            @one_time_password_session_form = one_time_password_session_form
            render :new
          end

          one_time_password_validator.validate(one_time_password_form_params)
        end

        private
        def one_time_password_validator
          @one_time_password_validator ||= ::Users::Sessions::OneTimePasswordValidator.new(user: current_user, event_logger: user_event_logger)
        end

        def one_time_password_form_params
          params.require(:one_time_password_form).permit(:otp)
        end
      end
    end
  end
end