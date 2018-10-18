module Users
  module Emails
    class ConfirmationsController < ::Users::ApplicationController
      before_filter :load_user

      def show
        @user.update_attributes email_confirmed: true

        flash[:notice] = 'Your email has been confirmed.'

        if current_user == @user
          if current_user.current_accounts.count == 1
            redirect_to [:users, current_user.current_accounts.first]
          else
            redirect_to [:users, :accounts]
          end
        else
          redirect_to [:root]
        end
      end

      private
      def load_user
        @user = ::Users::User.find_by_email_token(token)
      end

      def token
        URI.unescape(params[:token])
      end
      helper_method :token
    end
  end
end