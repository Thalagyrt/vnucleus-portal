module Admin
  module Accounts
    class TicketsController < Admin::Accounts::ApplicationController
      decorates_assigned :tickets, :ticket

      power :admin_account_tickets, context: :load_account, as: :tickets_scope, map: { [:new, :create] => :creatable_admin_account_tickets }

      def index
        @tickets = tickets_scope.includes(:account)

        respond_to do |format|
          format.html
          format.json { render json: TicketsDatatable.new(@tickets, view_context) }
        end
      end

      def show
        @ticket = tickets_scope.find_by_param(params[:id])

        ::Users::Notification.where(user: current_user, target: @ticket).mark_all_read
      end

      def new
        current_power.admin_account_tickets!(@account)

        @ticket_form = ::Tickets::TicketForm.new
      end

      def create
        current_power.admin_account_tickets!(@account)

        ticket_creator.on(:create_success) do |ticket|
          flash[:notice] = 'Your ticket has been created.'
          redirect_to [:admin, @account, ticket]
        end
        ticket_creator.on(:create_failure) do |ticket_form|
          @ticket_form = ticket_form
          render :new
        end

        ticket_creator.create(ticket_params)
      end

      private
      def ticket_creator
        @ticket_creator ||= ::Tickets::TicketCreator.new(account: @account, user: current_user)
      end

      def ticket_params
        params.require(:ticket_form).permit(:subject, :body, :secure_body, :priority)
      end
    end
  end
end