module Users
  module Authenticated
    module Accounts
      class AffiliatesController < ::Users::Authenticated::Accounts::ApplicationController
        decorates_assigned :transactions

        def show
          current_power.account_affiliates!(account)

          @transactions = account.transactions.find_referrals
        end
      end
    end
  end
end