module Provisioning
  class ApplicationController < ::ApplicationController
    before_filter :load_server

    private
    attr_reader :server
    helper_method :server

    def load_server
      @server = servers_scope.find_by!(ip_address: request.remote_ip)
    end

    def servers_scope
      ::Solus::Server.find_pending_completion
    end
  end
end