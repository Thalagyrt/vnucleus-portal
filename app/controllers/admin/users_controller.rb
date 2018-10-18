module Admin
  class UsersController < Admin::ApplicationController
    decorates_assigned :users, :user

    power :admin_users, as: :users_scope

    def index
      @users = users_scope
    end

    def show
      @user = users_scope.find(params[:id])
    end
  end
end