module Solus
  class VncConsoleService
    def initialize(opts = {})
      @server = opts.fetch(:server)
      @api_client = opts.fetch(:api_client) { ApiClientService.new(cluster: cluster) }
    end

    def console
      api_command('vserver-vnc', console_options) do |response|
        VncConsole.new(hostname: response.vncip, port: response.vncport, password: response.vncpassword)
      end
    end

    private
    attr_reader :server, :api_client
    delegate :cluster, to: :server
    delegate :api_command, to: :api_client

    def console_options
      {
          vserverid: server.vserver_id
      }
    end
  end
end