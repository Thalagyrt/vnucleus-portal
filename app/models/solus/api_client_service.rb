require 'solus/api/request'

module Solus
  class ApiClientService
    def initialize(opts = {})
      @cluster = opts.fetch(:cluster)
    end

    def api_command(action, options={}, &block)
      response = ::Solus::Api::Request.new(cluster.ip_address, cluster.api_id, cluster.api_secret, action, options).response

      if response.success?
        block ? block.call(response) : response
      else
        false
      end
    end

    private
    attr_reader :cluster
  end
end