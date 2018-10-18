module Users
  module Authenticated
    module Accounts
      class LicensesController < Accounts::ApplicationController
        decorates_assigned :licenses

        power :account_licenses, context: :load_account, as: :licenses_scope

        def index
          @licenses = licenses_scope
        end
      end
    end
  end
end