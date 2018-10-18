module Users
  module Authenticated
    module Accounts
      module Solus
        module Servers
          class ConfirmationsController < ::Users::Authenticated::Accounts::Solus::Servers::ApplicationController
            power :account_solus_servers, context: :load_account, as: :servers_scope, map: { [:create] => :confirmable_account_solus_servers }

            before_filter :ensure_confirmable

            def create
              server_confirmer.on(:confirm_success) do
                flash[:notice] = "Your server has been confirmed and is queued for delivery."
                redirect_to [:users, @account, :solus, @server]
              end

              server_confirmer.confirm
            end

            def destroy
              @server.cancel_order

              flash[:notice] = "Your server order has been canceled."
              redirect_to [:users, @account, :solus, :servers]
            end

            private
            def server_confirmer
              @server_confirmer ||= ::Solus::ServerConfirmer.new(server: @server, event_logger: account_event_logger, user: current_user)
            end

            def ensure_confirmable
              unless @server.can_confirm?
                flash[:notice] = "This server is not in a state that allows confirmation."
                redirect_to [:users, @account, :solus, @server]
              end
            end
          end
        end
      end
    end
  end
end