module Solus
  class SshConsoleService
    def initialize(opts = {})
      @server = opts.fetch(:server)
      @api_client = opts.fetch(:api_client) { ApiClientService.new(cluster: cluster) }
    end

    def console
      Rails.logger.info { "Creating console for #{server}" }

      api_command('vserver-console', console_options) do |response|
        SshConsole.new(hostname: response.consoleip, port: response.consoleport, username: response.consoleusername, password: response.consolepassword)
      end
    end

    private
    attr_reader :server, :api_client
    delegate :cluster, to: :server
    delegate :api_command, to: :api_client

    def console_options
      {
          vserverid: server.vserver_id,
          access: 'enable'
      }
    end
  end
end