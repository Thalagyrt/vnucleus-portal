module Solus
  class ConsolePolicy
    def initialize(opts = {})
      @server = opts.fetch(:server)
    end

    def type
      case server.virtualization_type
        when 'xen'
          :ssh
        when 'xen hvm'
          :vnc
        when 'kvm'
          :vnc
        else
          raise ArgumentError.new('Server virtualization type must be xen, xen hvm, or kvm')
      end
    end

    private
    attr_reader :server
  end
end