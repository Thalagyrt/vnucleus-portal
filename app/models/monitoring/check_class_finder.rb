module Monitoring
  class CheckClassFinder
    CheckClasses = {
        icmp: CheckICMP,
        tcp: CheckTCP,
        http: CheckHTTP,
        ssl_validity: CheckSSLValidity,
        nrpe: CheckNRPE,
    }

    def initialize(opts = {})
      @check = opts.fetch(:check)
    end

    def check_class
      CheckClasses[check_type.to_sym]
    end

    private
    attr_reader :check
    delegate :check_type, to: :check
  end
end