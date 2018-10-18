module Solus
  class IpAddress
    include ActiveModel::Model
    include Draper::Decoratable

    validates :ptr_value, hostname: true, if: :ip_address_present?
    validate :ensure_ptr_settable

    def initialize(opts = {})
      @address = opts.fetch(:address)
    end

    def ptr_value
      @ptr_value ||= Rails.cache.fetch("ptr.#{address}", expires_in: Rails.application.config.ptr_cache_time) do
        begin
          Resolv.getname(address)
        rescue Resolv::ResolvError
          nil
        end
      end
    end

    def ptr_value=(value)
      @ptr_value = value.downcase
    end

    def save
      return false unless valid?

      if ptr_value.present?
        reverse_dns_updater.update(ptr_value)
      else
        reverse_dns_updater.destroy

        true
      end
    end

    def ptr_settable?
      mapper.present?
    end

    def persisted?
      true
    end

    def id
      address
    end

    def to_s
      address
    end

    def anchor_name
      address.gsub('.', '-').gsub(':', '-')
    end

    def reverse_dns_updater
      @reverse_dns_updater ||= ReverseDnsUpdater.new(ip_address: address)
    end

    attr_reader :address

    private
    def mapper
      @mapper ||= ReverseDnsMapping.find_for_ip(address)
    end

    def ip_address_present?
      ptr_value.present?
    end

    def ensure_ptr_settable
      unless ptr_settable?
        errors[:ptr_value] << 'address can not be configured automatically'
      end
    end
  end
end