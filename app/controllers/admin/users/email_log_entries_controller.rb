module Admin
  module Users
    class EmailLogEntriesController < Admin::Users::ApplicationController
      power :admin_user_email_log_entries, context: :load_user, as: :email_log_entries_scope

      decorates_assigned :email_log_entries

      def index
        render json: Users::EmailLogEntriesDatatable.new(email_log_entries_scope.includes(:user), view_context)
      end
    end
  end
end