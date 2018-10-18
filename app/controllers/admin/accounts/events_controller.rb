module Admin
  module Accounts
    class EventsController < Admin::Accounts::ApplicationController
      decorates_assigned :events

      power :admin_account_events, context: :load_account, as: :events_scope

      def index
        @events = events_scope.includes(:user, :entity)
      end
    end
  end
end