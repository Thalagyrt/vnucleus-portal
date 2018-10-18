module Users
  module Authenticated
    module Accounts
      class MembershipsController < Accounts::ApplicationController
        power :account_memberships, context: :load_account, as: :memberships_scope, map: { [:edit, :update, :destroy] => :updatable_account_memberships }

        decorates_assigned :membership, :memberships

        def index
          @memberships = memberships_scope.includes(:user)
        end

        def edit
          @membership = memberships_scope.find_by_param(params[:id])
        end

        def update
          @membership = memberships_scope.find_by_param(params[:id])

          @membership.update_attributes!(membership_params)

          flash[:notice] = "The user's membership has been updated."
          redirect_to [:users, @account, :memberships]
        end

        def destroy
          @membership = memberships_scope.find_by_param(params[:id])

          @membership.destroy!

          flash[:notice] = "The user has been removed from your account."
          redirect_to [:users, @account, :memberships]
        end

        private
        def membership_params
          params.require(:membership).permit(roles: [])
        end
      end
    end
  end
end