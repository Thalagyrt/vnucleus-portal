module Users
  module Authenticated
    class ProfilesController < Users::Authenticated::ApplicationController
      def edit
        @user = current_user

        if params[:return_to].present?
          session[:return_to] = params[:return_to]
        end
      end

      def update
        profile_updater.on(:update_success) do
          flash[:notice] = 'Your profile has been updated.'

          if session[:return_to].present?
            redirect_to session.delete(:return_to)
          else
            redirect_to [:users, :accounts]
          end
        end
        profile_updater.on(:update_failure) do |user|
          @user = user

          render :edit
        end

        profile_updater.update(user_params.merge(profile_complete: true))
      end

      private
      def profile_updater
        @profile_updater ||= AuthenticatedUserUpdater.new(user: current_user)
      end

      def user_params
        params.require(:user).permit(
            :email, :password, :password_confirmation, :current_password, :phone,
            :security_question, :security_answer, :first_name, :last_name, :enhanced_security,
            :receive_security_bulletins, :receive_product_announcements
        )
      end
    end
  end
end