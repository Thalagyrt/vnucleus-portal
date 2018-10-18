module Admin
  class EmailLogEntriesController < Admin::ApplicationController
    power :admin_email_log_entries, as: :email_log_entries_scope

    decorates_assigned :email_log_entries, :email_log_entry

    def index
      respond_to do |format|
        format.html
        format.json { render json: EmailLogEntriesDatatable.new(email_log_entries_scope.includes(:user), view_context) }
      end
    end

    def show
      @email_log_entry = email_log_entries_scope.find_by_param(params[:id])
    end
  end
end