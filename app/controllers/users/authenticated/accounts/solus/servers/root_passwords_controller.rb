module Users
  module Authenticated
    module Accounts
      module Solus
        module Servers
          class RootPasswordsController < ::Users::Authenticated::Accounts::Solus::Servers::ApplicationController
            def show
              respond_to do |format|
                format.js do
                  account_event_logger.with_entity(@server).with_category(:access).log(:root_password_viewed)
                end

                format.html { redirect_to [:users, @account, :solus, @server] }
              end
            end
          end
        end
      end
    end
  end
end