module Solus
  class PreseedRenderer
    def initialize(server)
      @server = server
    end

    def render
      ERB.new(preseed_template || "").result(binding)
    end

    private
    attr_reader :server
    delegate :template, to: :server
    delegate :preseed_template, to: :template
  end
end