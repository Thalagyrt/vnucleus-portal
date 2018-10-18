module Admin
  module Accounts
    module Dedicated
      module Servers
        class RootPasswordsController < Admin::Accounts::Dedicated::Servers::ApplicationController
          def show
            respond_to do |format|
              format.js do
                account_event_logger.with_entity(@server).with_category(:access).log(:root_password_viewed)
              end

              format.html { redirect_to [:admin, @account, :dedicated, @server] }
            end
          end
        end
      end
    end
  end
end