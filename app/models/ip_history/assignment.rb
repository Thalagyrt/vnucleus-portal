module IpHistory
  class Assignment < ActiveRecord::Base
    belongs_to :server, polymorphic: true

    validates :server, presence: true
    validates :ip_address, presence: true

    scope :sorted, -> { order('created_at DESC') }

    def self.query(ip_address, timestamp)
      with_ip(ip_address).where('created_at < ?', timestamp).where('last_seen_at > ?', timestamp).first
    end

    def self.with_ip(ip_address)
      where(ip_address: ip_address)
    end

    def self.record_usage(server, ip_address)
      current_record = with_ip(ip_address).sorted.first

      if current_record.present? && current_record.server == server
        current_record.update last_seen_at: Time.zone.now
      else
        create(server: server, ip_address: ip_address, last_seen_at: Time.zone.now)
      end
    end
  end
end