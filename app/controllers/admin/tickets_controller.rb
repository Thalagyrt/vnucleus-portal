module Admin
  class TicketsController < Admin::ApplicationController
    power :admin_tickets, as: :tickets_scope

    decorates_assigned :tickets

    def index
      @tickets = tickets_scope.includes(:account)

      respond_to do |format|
        format.html
        format.json { render json: TicketsDatatable.new(@tickets, view_context) }
      end
    end
  end
end