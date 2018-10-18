module Monitoring
  class Check < ActiveRecord::Base
    include Concerns::LongIdModelConcern

    include PgSearch
    extend Enumerize

    has_many :results, dependent: :destroy
    has_many :performance_metrics, through: :results
    has_many :notifications
    has_many :check_notification_targets
    has_many :notification_targets, through: :check_notification_targets

    belongs_to :server, polymorphic: true
    belongs_to :account, class_name: ::Accounts::Account, inverse_of: :monitoring_checks

    enumerize :check_type, in: { icmp: 1, tcp: 2, http: 3, ssl_validity: 4, nrpe: 5 }
    enumerize :status_code, in: { ok: 0, warning: 1, critical: 2, unknown: 3 }

    validates :check_type, presence: true
    validates :server, presence: true

    validate :validate_check_data

    before_save :set_next_run_at
    before_save :update_server_caches
    before_save :update_check_caches
    before_save :update_account_id

    scope :exclude_deleted, -> { where(deleted: false) }
    scope :find_failing, -> { where.not(status_code: 0) }
    scope :find_enabled, -> { where(enabled: true) }
    scope :find_runnable, -> { find_enabled.where('next_run_at < ?', Time.zone.now) }

    pg_search_scope :search,
                    against: { server_hostname: 'B', server_long_id: 'C', test_to_s: 'A' },
                    using: {
                        tsearch: {
                            prefix: true,
                            dictionary: 'english'
                        }
                    }

    class << self
      def reset_all
        update_all enabled: true, verified: false
      end

      def disable_all
        update_all enabled: false, verified: false
      end

      def muzzle_all(duration)
        update_all muzzle_until: Time.zone.now + duration
      end
    end

    def successful?
      status_code.to_sym == :ok
    end

    def priority
      case status_code.to_sym
        when :critical
          :high
        else
          :low
      end
    end

    def to_s
      "#{test_to_s} (#{long_id}) on #{server.server_type_string} #{server.to_s}"
    end

    def test_to_s
      case check_type.to_sym
        when :icmp
         "ICMP"
        when :tcp
          "TCP #{check_data}"
        when :http
          check_data
        when :ssl_validity
          "Certificate validity on #{check_data}"
        when :nrpe
          check_data
      end
    end

    def status_message
      "#{server.to_s}: #{status_message_short}"
    end

    def status_message_short
      message = "#{test_to_s} is #{status_code.upcase}"

      message = "#{message} (#{last_result.status})" if last_result.present? && last_result.status.present?

      message
    end

    def active?
      enabled? && server.active?
    end

    def muzzle(duration)
      update muzzle_until: Time.zone.now + duration
    end

    def muzzled?
      muzzle_until.present? && muzzle_until > Time.zone.now
    end

    def disable_reason
      if !server.active?
        :server_inactive
      elsif !enabled?
        :manually_disabled
      else
        nil
      end
    end

    def record_result(data)
      results.create!(data).tap do |result|
        if result.successful?
          self.verified = true
          self.failure_count = 0
          self.next_run_at = Time.zone.now + 2.minutes + rand(60).seconds # Mild randomization to keep load distributed
        else
          self.failure_count += 1
          self.next_run_at = Time.zone.now # Run immediately in the next slot
        end

        self.last_run_at = Time.zone.now
        self.status_code = result.status_code

        save!
      end
    end

    def last_result
      results.sorted.first
    end

    def can_enable?
      server.active?
    end

    def should_notify?
      verified? && !muzzled? && failure_count >= notify_after_failures
    end

    def should_resolve_low?
      failure_count == 0
    end

    def should_resolve_high?
      priority == :low
    end

    def verified_notification_targets
      notification_targets.find_verified
    end

    delegate :ip_address, to: :server

    private
    def set_next_run_at
      self.next_run_at ||= Time.zone.now
    end

    def validate_check_data
      return unless check_type.present?

      case check_type.to_sym
        when :http, :ssl_validity
          if check_data.present?
            uri = URI(check_data)

            errors[:check_data] << 'invalid URL' unless uri.hostname.present?
            errors[:check_data] << 'port is missing' unless uri.port.present?
            errors[:check_data] << 'scheme must be http or https' unless uri.scheme.present? && uri.scheme.starts_with?('http')
          else
            errors[:check_data] << 'must specify a target'
          end
        when :tcp
          if check_data.present?
            errors[:check_data] << 'must be a port number' unless check_data.to_i.to_s == check_data.to_s
          else
            errors[:check_data] << 'must specify a target'
          end
        when :icmp
          errors[:check_data] << 'must be empty' if check_data.present?
        when :nrpe
          errors[:check_data] << 'must be present' unless check_data.present?
      end
    end

    def update_server_caches
      self.server_hostname = server.hostname
      self.server_long_id = server.long_id
    end

    def update_check_caches
      self.test_to_s = test_to_s
    end

    def update_account_id
      self.account_id = server.account_id
    end
  end
end