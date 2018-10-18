module Admin
  module Accounts
    class BackupUsersController < Admin::Accounts::ApplicationController
      decorates_assigned :backup_users, :backup_user

      power :admin_account_backup_users, context: :load_account, as: :backup_users_scope

      def index
        @backup_users = backup_users_scope
      end

      def new
        @backup_user = backup_users_scope.new
      end

      def create
        @backup_user = backup_users_scope.new(backup_user_params)

        if @backup_user.save
          flash[:notice] = 'The backup user has been added.'
          redirect_to [:admin, @account, :backup_users]
        else
          render :new
        end
      end

      def edit
        @backup_user = backup_users_scope.find(params[:id])
      end

      def update
        @backup_user = backup_users_scope.find(params[:id])

        if @backup_user.update_attributes(backup_user_params)
          flash[:notice] = 'The backup user has been updated.'
          redirect_to [:admin, @account, :backup_users]
        else
          render :edit
        end
      end

      def destroy
        @backup_user = backup_users_scope.find(params[:id])

        if @backup_user.destroy
          flash[:notice] = 'The backup user has been removed.'
        end

        redirect_to [:admin, @account, :backup_users]
      end

      private
      def backup_user_params
        params.require(:backup_user).permit(:username, :password, :hostname)
      end
    end
  end
end