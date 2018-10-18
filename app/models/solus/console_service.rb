module Solus
  class ConsoleService
    def initialize(opts = {})
      @server = opts.fetch(:server)
      @console_policy = opts.fetch(:console_policy) { ConsolePolicy.new(server: server) }
    end

    delegate :console, to: :console_service

    private
    attr_reader :server, :console_policy
    delegate :type, to: :console_policy

    def console_service
      console_service_class.new(server: server)
    end

    def console_service_class
      "Solus::#{type.to_s.camelize}ConsoleService".constantize
    end
  end
end