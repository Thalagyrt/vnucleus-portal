module Monitoring
  class CheckMuzzler
    include Wisper::Publisher

    def initialize(opts = {})
      @check = opts.fetch(:check)
    end

    def muzzle(params)
      muzzle = Muzzle.new(params)

      if muzzle.valid?
        check.muzzle muzzle.duration

        publish :muzzle_success
      else
        publish :muzzle_failure, muzzle
      end
    end

    private
    attr_reader :check
  end
end