module Users
  module Authenticated
    module Accounts
      module Solus
        module Servers
          class StatusesController < ::Users::Authenticated::Accounts::Solus::Servers::ApplicationController
            decorates_assigned :server_status

            def show
              @server_status = ::Solus::StatusService.new(server: @server).status
            end
          end
        end
      end
    end
  end
end