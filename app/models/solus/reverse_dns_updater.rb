module Solus
  class ReverseDnsUpdater
    def initialize(opts = {})
      @fog_dns = opts.fetch(:fog_dns) { Fog::DNS.new(Rails.application.config.fog) }
      @ip_address = IPAddr.new(opts.fetch(:ip_address))
    end

    def has_mapping?
      mapping.present?
    end

    def update(hostname)
      destroy

      if zone.records.new(value: hostname, name: record_name, type: 'PTR', ttl: 300).save
        Rails.logger.info { "Updated reverse DNS for #{ip_address} to #{hostname}" }

        Rails.cache.write("ptr.#{ip_address}", hostname, expires_in: Rails.application.config.ptr_cache_time)
        true
      else
        false
      end
    end

    def destroy
      return false unless has_mapping?
      return false unless zone.present?

      # AWS for some reason needs the / escaped.
      record = zone.records.get(record_name.sub('/', '\\\057'))

      if record && record.destroy
        Rails.logger.info { "Removed reverse DNS for #{ip_address}" }

        Rails.cache.write("ptr.#{ip_address}", '', expires_in: Rails.application.config.ptr_cache_time)
        true
      else
        false
      end
    end

    def rate_limit_sleep
      sleep 2.5
    end

    private
    attr_reader :fog_dns, :ip_address
    delegate :ipv4?, :ipv6?, to: :ip_address

    def record_name
      if ipv4?
        "#{ip_address.to_s.split('.').last}.#{mapping.record_suffix}"
      else
        "#{ip_address.ip6_arpa}."
      end
    end

    def zone
      @zone ||= fog_dns.zones.get(mapping.zone_id)
    end

    def mapping
      @mapping ||= ReverseDnsMapping.find_for_ip(ip_address)
    end
  end
end