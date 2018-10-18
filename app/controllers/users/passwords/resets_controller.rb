module Users
  module Passwords
    class ResetsController < Users::Passwords::ApplicationController
      before_filter :load_user

      def new
        @reset_form = ResetForm.new
      end

      def create
        @reset_form = ResetForm.new(reset_params)

        if @reset_form.valid?
          @user.update_attribute :password, @reset_form.password
          @user.expire_sessions!
          flash[:notice] = 'Your password has been reset.'
          redirect_to root_path
        else
          render :new
        end
      end

      private
      def reset_params
        params.require(:reset_form).permit(:password, :password_confirmation)
      end

      def token
        URI.unescape(params[:token])
      end
      helper_method :token

      def load_user
        @user = Users::User.find_by_reset_token(token)
      end
    end
  end
end