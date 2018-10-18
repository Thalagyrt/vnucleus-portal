module Solus
  class IpAddressIndexService
    def initialize(opts = {})
      @server = opts.fetch(:server)
    end

    def ip_addresses
      ip_address_list.map { |address| IpAddress.new(address: address) }.select(&:ptr_settable?)
    end

    def find(address)
      raise ActiveRecord::NotFound unless ip_address_list.include?(address)

      ip_address = IpAddress.new(address: address)

      raise ActiveRecord::NotFound unless ip_address.ptr_settable?

      ip_address
    end

    private
    attr_reader :server
    delegate :ip_address_list, to: :server
  end
end