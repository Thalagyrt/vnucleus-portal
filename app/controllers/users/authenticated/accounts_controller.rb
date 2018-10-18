module Users
  module Authenticated
    class AccountsController < Users::Authenticated::ApplicationController
      layout :resolve_layout

      power :user_accounts, as: :accounts_scope

      decorates_assigned :account, :accounts

      def index
        @accounts = accounts_scope
        @accounts = @accounts.find_current unless params[:show_all].present?
      end

      def new
        @account_form = ::Accounts::AccountForm.new(account_entity_name: current_user.full_name, credit_card_name: current_user.full_name, affiliate_id: cookies[:affiliate_id])
      end

      def create
        account_creator.on(:create_success) do |account|
          if account.active?
            redirect_to [:new, :users, account, :solus, :server]
          else
            redirect_to [:users, account]
          end
        end
        account_creator.on(:create_failure) do |account_form|
          @account_form = account_form
          render :new
        end

        account_creator.create(account_form_params)
      end

      def show
        @account = accounts_scope.find_by_param(params[:id])
      end

      def edit
        @account = accounts_scope.find_by_param(params[:id])

        current_power.account_full_access!(@account)
      end

      def update
        @account = accounts_scope.find_by_param(params[:id])

        current_power.account_full_access!(@account)

        if @account.update_attributes(update_account_params)
          redirect_to [:users, @account]
        else
          render :edit
        end
      end

      private
      def account_creator
        @account_creator ||= ::Accounts::AccountCreator.new(user: current_user, request: request)
      end

      def account_form_params
        params.require(:account_form).permit(
            :account_entity_name, :account_nickname, :credit_card_token, :credit_card_address_line1, :credit_card_address_line2,
            :credit_card_address_city, :credit_card_address_state, :credit_card_address_zip, :credit_card_address_country,
            :credit_card_name, :credit_card_expiration_month, :credit_card_expiration_year, :affiliate_id
        )
      end

      def update_account_params
        params.require(:account).permit(:entity_name, :nickname)
      end

      def resolve_layout
        case action_name
          when "index", "new", "create"
            "users/application"
          else
            "users/authenticated/accounts/application"
        end
      end
    end
  end
end