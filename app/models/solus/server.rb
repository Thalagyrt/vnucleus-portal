module Solus
  class Server < ActiveRecord::Base
    include Concerns::LongIdModelConcern
    include PgSearch
    extend Enumerize

    visitable :visit, class_name: Ahoy::Visit

    belongs_to :account, class_name: Accounts::Account, inverse_of: :solus_servers
    belongs_to :plan, inverse_of: :servers
    belongs_to :template, inverse_of: :servers
    belongs_to :cluster, inverse_of: :servers
    belongs_to :node, inverse_of: :servers
    belongs_to :coupon, class_name: Orders::Coupon
    belongs_to :backup_user, class_name: Accounts::BackupUser, inverse_of: :solus_servers
    belongs_to :console_locked_by, class_name: Users::User
    belongs_to :console_requested_by, class_name: Users::User

    serialize :ip_address_list

    has_many :events, class_name: Accounts::Event, as: :entity
    has_many :monitoring_checks, class_name: Monitoring::Check, as: :server

    validates :account, presence: true
    validates :plan, presence: { message: 'plan is required' }
    validates :cluster, presence: { message: 'location is required' }
    validates :template, presence: { message: 'operating system is required' }
    validates :hostname, hostname: true, presence: true
    validates :plan_amount, presence: true, numericality: { greater_than_or_equal_to: 0 }
    validates :template_amount, presence: true, numericality: { greater_than_or_equal_to: 0 }

    scope :find_managed, -> { joins(:plan).where(solus_plans: { managed: true }) }
    scope :find_legacy, -> { joins(:plan).merge(Solus::Plan.legacy) }

    pg_search_scope :search,
                    against: { xen_id: 'B', long_id: 'C', hostname: 'A', ip_address: 'B' },
                    associated_against: {
                        account: { long_id: 'C', name: 'B' },
                        plan: { name: 'B' },
                        template: { name: 'B' },
                        cluster: { name: 'B' },
                        node: { name: 'B' }
                    },
                    using: {
                        tsearch: {
                            prefix: true,
                            dictionary: 'english'
                        }
                    }

    def to_s
      "#{long_id} (#{hostname})"
    end

    def server_type_string
      "Server"
    end

    concerning :AccountCaches do
      included do
        after_save :update_account_caches
      end

      private
      def update_account_caches
        account.update_monthly_rate_cache!
        account.update_server_count_cache!
      end
    end

    concerning :Automation do
      included do
        scope :find_automation_suspendible, -> { find_active.where('suspend_on <= ?', Time.zone.today) }
        scope :find_automation_suspended, -> { where(state: :automation_suspended) }
        scope :find_automation_terminatable, -> { find_automation_suspended.where('terminate_on <= ?', Time.zone.today) }
        scope :find_pending_synchronization, -> { find_active.where('synchronize_at <= ?', Time.zone.now)}

        before_create :set_synchronize_at
      end

      def pending_suspension?
        active? && suspend_on.present?
      end

      def pending_termination?
        suspended? && terminate_on.present?
      end

      def synchronized?
        synchronized_at.present?
      end

      def reinstallable?
        active? && plan.reinstallable?
      end

      private
      def set_synchronize_at
        self.synchronize_at ||= Time.zone.now + 24.hours
      end
    end

    concerning :Billing do
      included do
        def self.monthly_rate
          sum(:amount)
        end

        scope :find_due, -> { find_active.where('next_due <= ?', Time.zone.today) }
        scope :find_stale_orders, -> { find_pending_confirmation.where('created_at <= ?', 3.days.ago) }
        scope :find_billable, -> { find_current.find_conversions }

        before_save :update_amount
      end

      def bill_to(ledger, event_logger)
        with_lock do
          logger.info { "Billing server #{to_s} to account #{account}"}

          if billable?
            ledger.add_debit(overage_amount, "Virtual Server #{to_s} bandwidth overage of #{overage_gb} GB") if overage?

            ledger.add_debit(amount, "Virtual Server #{to_s} from #{next_due} through #{new_next_due - 1.day}")
          end

          event_logger.with_entity(self).log(:server_billed)

          self.used_transfer = 0
          push_next_due!
        end
      end

      def used_transfer_ratio
        used_transfer.to_f / transfer.to_f
      end

      def used_transfer_percentage
        (used_transfer_ratio * 100).to_i
      end

      def plan_amount_dollars
        plan_amount / 100.0 if plan_amount
      end

      def plan_amount_dollars=(value)
        self.plan_amount = BigDecimal.new(value) * 100 if value.present?
      end

      def template_amount_dollars
        template_amount / 100.0 if template_amount
      end

      def template_amount_dollars=(value)
        self.template_amount = BigDecimal.new(value) * 100 if value.present?
      end

      def prorated_amount
        Prorater.new(next_due).prorate(amount)
      end

      def prorated_template_difference(template)
        difference = template.amount - template_amount

        Prorater.new(next_due).prorate(difference)
      end

      private
      def billable?
        amount > 0
      end

      def overage?
        used_transfer > transfer
      end

      def overage_amount
        overage_gb * Rails.application.config.transfer_overage_amount
      end

      def overage_gb
        (used_transfer - transfer) / 1.gigabyte
      end

      def update_amount
        self.amount = plan_amount + template_amount
      end

      def push_next_due
        self.next_due = new_next_due
      end

      def push_next_due!
        push_next_due
        save!
      end

      def new_next_due
        next_due + 1.month
      end
    end

    concerning :Clusters do
      def cluster_name
        cluster.name
      end

      def node_name
        node.try(:name)
      end
    end

    concerning :Consoles do
      def console_locked?
        console_locked_until.present? && console_locked_until > Time.zone.now
      end

      def lock_console_for!(user)
        return false if console_locked?

        self.console_locked_by = user
        self.console_lock_id = SecureRandom.uuid
        self.console_requested_by = nil
        console_heartbeat!(console_lock_id)
      end

      def request_console_for!(user)
        self.console_requested_by = user
        save!
      end

      def console_heartbeat!(lock_id)
        return false unless console_lock_id.present? && lock_id == console_lock_id

        self.console_locked_until = Time.zone.now + console_lock_duration
        save!
      end

      private
      def console_lock_duration
        Rails.application.config.console_locks[:duration]
      end
    end

    concerning :Coupons do
      def coupon_code
        coupon.coupon_code
      end
    end

    concerning :IpAddresses do
      included do
        after_initialize do
          self.ip_address_list ||= []
        end
      end

      def ipv4_address_list
        ip_address_list.select { |address| IPAddr.new(address).ipv4? }
      end

      def ipv6_address_list
        ip_address_list.select { |address| IPAddr.new(address).ipv6? }
      end
    end

    concerning :Monitoring do
      def has_checks?
        monitoring_checks.present?
      end

      def monitoring_disable
        monitoring_checks.disable_all
      end

      def monitoring_reset
        monitoring_checks.reset_all
      end

      def monitoring_reboot
        monitoring_muzzle 5.minutes
      end

      def monitoring_muzzle(duration)
        monitoring_checks.muzzle_all duration
      end
    end

    concerning :Plans do
      included do
        delegate :ram, :vcpus, :ip_addresses, :ipv6_addresses, :node_group, :managed?, to: :plan
      end

      def plan_name
        plan.name
      end

      def plan_string
        "#{template.plan_part}#{plan.plan_part}"
      end

      def transfer_tb
        transfer.to_f / 1.terabyte if transfer
      end

      def transfer_tb=(value)
        self.transfer = value.to_f * 1.terabyte if value.present?
      end
    end

    concerning :Patches do
      included do
        scope :find_pending_patches, -> { find_active.where('patch_at <= ? OR patch_out_of_band = ?', Time.zone.today, true) }
        scope :find_pending_patch_incidents, -> { find_pending_patches.where(patch_incident_key: nil) }
        enumerize :patch_period_unit, in: ['days', 'months'], default: 'months'

        validates :patch_period, presence: true, if: -> { patch_at.present? }
        validates :patch_period_unit, presence: true, if: -> { patch_at.present? }
      end

      def patched!
        if patch_at.present? && patch_at <= Time.zone.now
          self.patch_at = new_patch_at
        end

        if patch_out_of_band?
          self.patch_out_of_band = false
        end

        save!
      end

      def patches_due?
        (patch_at.present? && patch_at <= Time.zone.today) || patch_out_of_band?
      end

      def new_patch_at
        patch_at + patch_period.public_send(patch_period_unit)
      end
    end

    concerning :State do
      TERMINATED_STATES = [:automation_terminated, :admin_terminated, :user_terminated, :pending_automation_termination, :pending_admin_termination, :pending_user_termination, :order_cancelled]
      PENDING_STATES = [:pending_confirmation, :order_cancelled]

      included do
        scope :find_active, -> { where(state: :active) }
        scope :find_pending_confirmation, -> { where(state: :pending_confirmation) }
        scope :find_pending_completion, -> { where(state: :pending_completion) }
        scope :find_pending_payment, -> { where(state: :pending_payment) }
        scope :find_pending_provision, -> { where(state: :pending_provision) }
        scope :find_current, -> { where('solus_servers.state NOT IN (?)', TERMINATED_STATES) }
        scope :find_conversions, -> { where('state NOT IN (?)', PENDING_STATES) }

        state_machine :state, initial: :pending_confirmation do
          event :confirm do
            transition :pending_confirmation => :pending_billing
          end

          event :cancel_order do
            transition :pending_confirmation => :order_cancelled
          end

          event :billed do
            transition :pending_billing => :pending_payment
          end

          event :paid do
            transition :pending_payment => :pending_provision
          end

          before_transition any => :pending_provision do |server, _|
            server.provision_started_at = Time.zone.now
            server.provision_id = SecureRandom.uuid
          end

          event :provision do
            transition :pending_provision => :pending_completion
          end

          event :complete do
            transition :pending_completion => :active
          end

          before_transition any => :active do |server, _|
            server.provision_completed_at = Time.zone.now
          end

          event :schedule_reinstall do
            transition :active => :pending_reinstall
          end

          event :automation_suspend do
            transition :active => :automation_suspended
          end

          event :admin_suspend do
            transition :active => :admin_suspended
          end

          event :unsuspend do
            transition [:admin_suspended, :automation_suspended] => :active
          end

          event :schedule_termination do
            transition :active => :pending_user_termination
            transition :admin_suspended => :pending_admin_termination
          end

          event :schedule_automation_termination do
            transition any => :pending_automation_termination
          end

          event :reject do
            transition :active => :pending_admin_termination
          end

          event :terminate do
            transition :pending_user_termination => :user_terminated
            transition :pending_automation_termination => :automation_terminated
            transition :pending_admin_termination => :admin_terminated
            transition :pending_reinstall => :pending_provision
          end
        end
      end

      def suspended?
        [:automation_suspended, :admin_suspended].include? state_name
      end

      def terminated?
        TERMINATED_STATES.include? state_name
      end

      def provisioning?
        [:pending_reinstall, :pending_billing, :pending_provision, :pending_completion].include? state_name
      end

      def provision_duration
        if provision_completed_at && provision_started_at
          provision_completed_at - provision_started_at
        end
      end
    end

    concerning :Templates do
      included do
        delegate :virtualization_type, :root_username, :install_time, :autocomplete_provision?, :is_cpanel?, to: :template
      end

      def template_name
        template.name
      end

      def template_string
        template.template
      end

      def preseed_body
        PreseedRenderer.new(self).render
      end
    end
  end
end