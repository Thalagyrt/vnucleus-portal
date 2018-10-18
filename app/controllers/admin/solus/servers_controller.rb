module Admin
  module Solus
    class ServersController < Admin::ApplicationController
      power :admin_solus_servers, as: :servers_scope

      decorates_assigned :servers

      def index
        @servers = servers_scope.includes(:plan, :template, :cluster, :account, :node)
        @servers = @servers.find_current unless params[:show_all].present?

        respond_to do |format|
          format.html
          format.json { render json: ServersDatatable.new(@servers, view_context) }
        end
      end
    end
  end
end