module Solus
  class GraphService
    def initialize(opts = {})
      @server = opts.fetch(:server)
      @api_client = opts.fetch(:api_client) { ApiClientService.new(cluster: cluster) }
      @image_class = opts.fetch(:image_class) { Image }
    end

    def transfer_graph
      @transfer_graph ||= begin
        response = api_client.api_command('vserver-infoall', vserverid: server.vserver_id)

        image_result = connection.get("https://#{cluster.hostname}:5656/#{response.trafficgraph}")

        image_class.new(data: image_result.body, content_type: image_result.headers['Content-Type'])
      rescue NoMethodError
        nil
      rescue Faraday::Error::TimeoutError
        nil
      end
    end

    private
    attr_reader :server, :api_client, :image_class
    delegate :cluster, to: :server

    def connection
      @connection ||= Faraday.new(ssl: ssl_options) do |faraday|
        faraday.adapter :net_http
        faraday.options[:timeout] = 30
        faraday.options[:open_timeout] = 20
      end
    end

    def ssl_options
      {
          verify: false
      }
    end
  end
end