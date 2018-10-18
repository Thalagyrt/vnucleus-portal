module Users
  module Sessions
    class SessionsController < Users::Sessions::ApplicationController
      def new
        return redirect_logged_in_user if current_user.present?

        @session_form = SessionForm.new
      end

      def create
        return redirect_logged_in_user if current_user.present?

        user_authenticator.on(:authentication_success) do |user|
          self.current_user = user
          flash[:notice] = "Welcome back, #{current_user.first_name}!"
          redirect_logged_in_user
        end
        user_authenticator.on(:authentication_failure) do |session_form|
          @session_form = session_form
          render :new
        end

        user_authenticator.authenticate(session_params)
      end

      def destroy
        self.current_user = nil
        self.otp_verified = nil
        flash[:notice] = 'You have been signed out.'
        redirect_to root_path
      end

      private
      def allow_registration?
        session[:allow_registration]
      end
      helper_method :allow_registration?

      def user_authenticator
        @user_authenticator ||= UserAuthenticator.new(request: request)
      end

      def session_params
        params.require(:session_form).permit(:email, :password)
      end
    end
  end
end