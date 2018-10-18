module Admin
  module Dedicated
    class ServersController < Admin::ApplicationController
      power :admin_dedicated_servers, as: :servers_scope

      decorates_assigned :servers

      def index
        @servers = servers_scope.includes(:account)
        @servers = @servers.find_current unless params[:show_all].present?

        respond_to do |format|
          format.html
          format.json { render json: ServersDatatable.new(@servers, view_context) }
        end
      end
    end
  end
end