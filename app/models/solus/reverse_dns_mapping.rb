module Solus
  class ReverseDnsMapping < ActiveRecord::Base
    validates :zone_id, presence: true
    validates :cidr_prefix, presence: true
    validates :record_suffix, presence: true

    class << self
      def find_for_ip(ip)
        all.find { |mapping| mapping.include? ip }
      end
    end

    delegate :include?, to: :cidr

    private
    def cidr
      @cidr ||= IPAddr.new(cidr_prefix)
    end
  end
end