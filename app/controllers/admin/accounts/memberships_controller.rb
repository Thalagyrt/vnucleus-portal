module Admin
  module Accounts
    class MembershipsController < Admin::Accounts::ApplicationController
      decorates_assigned :memberships

      power :admin_account_memberships, context: :load_account, as: :memberships_scope

      def index
        @memberships = memberships_scope.includes(:user)
      end
    end
  end
end