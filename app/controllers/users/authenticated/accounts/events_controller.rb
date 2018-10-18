module Users
  module Authenticated
    module Accounts
      class EventsController < Accounts::ApplicationController
        decorates_assigned :events

        power :account_events, context: :load_account, as: :events_scope

        def index
          @events = events_scope.includes(:user, :entity)
        end
      end
    end
  end
end