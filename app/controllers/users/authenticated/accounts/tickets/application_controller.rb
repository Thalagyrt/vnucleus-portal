module Users
  module Authenticated
    module Accounts
      module Tickets
        class ApplicationController < Accounts::ApplicationController
          decorates_assigned :ticket

          before_filter :assign_ticket

          power :account_tickets, context: :load_account, as: :tickets_scope, map: { [:new, :create] => :updatable_account_tickets }

          private
          def assign_ticket
            @ticket ||= tickets_scope.find_by_param(params[:ticket_id])
          end
        end
      end
    end
  end
end