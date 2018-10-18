module Admin
  module Users
    class ApplicationController < Admin::ApplicationController
      power :admin_users, as: :users_scope

      before_filter :load_user

      decorates_assigned :user

      private
      def load_user
        @user ||= users_scope.find(params[:user_id])
      end
    end
  end
end