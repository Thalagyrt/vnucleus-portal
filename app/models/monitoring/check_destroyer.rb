module Monitoring
  class CheckDestroyer
    def initialize(opts = {})
      @check = opts.fetch(:check)
    end

    def perform
      check.destroy
    end

    private
    attr_reader :check
  end
end