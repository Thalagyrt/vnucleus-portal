module Admin
  module Accounts
    module Solus
      module Servers
        class MuzzlesController < Admin::Accounts::Solus::Servers::ApplicationController
          def new
            @muzzle = ::Monitoring::Muzzle.new
          end

          def create
            server_muzzler = ::Monitoring::ServerMuzzler.new(server: @server)

            server_muzzler.on(:muzzle_success) do
              flash[:notice] = "The server's checks have been updated."
              render :create
            end

            server_muzzler.on(:muzzle_failure) do |muzzle|
              @muzzle = muzzle
              render :new
            end

            server_muzzler.muzzle(muzzle_params)
          end

          private
          def muzzle_params
            params.require(:muzzle).permit(:duration)
          end
        end
      end
    end
  end
end