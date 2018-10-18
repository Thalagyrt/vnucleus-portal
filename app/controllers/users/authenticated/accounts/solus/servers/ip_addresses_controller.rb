module Users
  module Authenticated
    module Accounts
      module Solus
        module Servers
          class IpAddressesController < Users::Authenticated::Accounts::Solus::Servers::ApplicationController
            before_filter :ensure_active

            def index
              @ip_addresses = ip_address_index_service.ip_addresses
            end

            def edit
              @ip_address = ip_address_index_service.find(params[:id])
            end

            def update
              @ip_address = ip_address_index_service.find(params[:id])

              @ip_address.ptr_value = params[:ip_address][:ptr_value]

              if @ip_address.save
                render :update
              else
                render :edit
              end
            end

            private
            def ip_address_index_service
              @ip_address_index_service ||= ::Solus::IpAddressIndexService.new(server: @server)
            end

            def ensure_active
              unless @server.active?
                flash[:notice] = "This server is not active."
                redirect_to [:users, @account, :solus, @server]
              end
            end
          end
        end
      end
    end
  end
end