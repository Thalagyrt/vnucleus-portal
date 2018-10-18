module Users
  module Authenticated
    module Accounts
      module Tickets
        class UpdatesController < ::Users::Authenticated::Accounts::Tickets::ApplicationController
          layout false

          decorates_assigned :updates, :update

          def index
            @updates = @ticket.updates.sorted.includes(:user)

            if params[:minimum_sequence]
              @updates = @updates.with_minimum_sequence(params[:minimum_sequence])
            end

            ::Users::Notification.where(user: current_user, target: @ticket).mark_all_read
          end

          def new
            @update = @ticket.updates.new(priority: @ticket.priority)
          end

          def create
            if params[:preview]
              @update = @ticket.updates.new(update_params.merge(user: current_user))

              render :preview
            else
              update_creator.on(:update_success) do
                @update = @ticket.updates.new(priority: @ticket.priority)
              end
              update_creator.on(:update_failure) do |update|
                @update = update
                render :new
              end

              update_creator.create(update_params)
            end
          end

          private
          def update_creator
            @update_creator ||= ::Tickets::UpdateCreator.new(ticket: @ticket, user: current_user)
          end

          def update_params
            params.require(:update).permit(:status, :body, :secure_body)
          end
        end
      end
    end
  end
end