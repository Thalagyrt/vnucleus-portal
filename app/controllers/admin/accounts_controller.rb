module Admin
  class AccountsController < Admin::ApplicationController
    layout :resolve_layout

    decorates_assigned :accounts, :account

    power :admin_accounts, as: :accounts_scope

    def index
      @accounts = accounts_scope
      @accounts = @accounts.find_current unless params[:show_all].present?

      respond_to do |format|
        format.html
        format.json { render json: AccountsDatatable.new(@accounts, view_context) }
      end
    end

    def show
      @account = accounts_scope.find_by_param(params[:id])

      ::Users::Notification.where(user: current_user, target: @account).mark_all_read
    end

    def edit
      @account = accounts_scope.find_by_param(params[:id])
    end

    def update
      @account = accounts_scope.find_by_param(params[:id])

      if @account.update_attributes(account_params)
        redirect_to [:admin, @account]
      else
        render :edit
      end
    end

    private
    def account_params
      params.require(:account).permit(:entity_name, :nickname, :affiliate_enabled)
    end

    def resolve_layout
      case action_name
        when "index"
          "admin/application"
        else
          "admin/accounts/application"
      end
    end
  end
end