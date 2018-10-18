module Monitoring
  class ServerMuzzler
    include Wisper::Publisher

    def initialize(opts = {})
      @server = opts.fetch(:server)
    end

    def muzzle(params)
      muzzle = Muzzle.new(params)

      if muzzle.valid?
        server.monitoring_muzzle muzzle.duration

        publish :muzzle_success
      else
        publish :muzzle_failure, muzzle
      end
    end

    private
    attr_reader :server
  end
end