module Solus
  class ConsoleSession < ActiveRecord::Base
    scope :find_stale, -> { where 'updated_at < ?', Time.zone.now - Rails.application.config.console_server[:expires_after] }

    class << self
      def target(ip_address, hostname, port)
        where(ip_address: ip_address).first_or_create.tap do |session|
          session.target(hostname, port)
        end
      end
    end

    def target(hostname, port)
      update_attributes target_hostname: hostname, target_port: port, updated_at: Time.zone.now
    end
  end
end