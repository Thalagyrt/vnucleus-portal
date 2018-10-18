module Admin
  module Accounts
    module Solus
      module Servers
        class RootPasswordsController < Admin::Accounts::Solus::Servers::ApplicationController
          def show
            respond_to do |format|
              format.js do
                account_event_logger.with_entity(@server).with_category(:access).log(:root_password_viewed)
              end

              format.html { redirect_to [:admin, @account, :solus, @server] }
            end
          end
        end
      end
    end
  end
end