module Dedicated
  class Server < ActiveRecord::Base
    include Concerns::LongIdModelConcern
    extend Enumerize

    belongs_to :account, class_name: Accounts::Account, inverse_of: :dedicated_servers
    belongs_to :backup_user, class_name: Accounts::BackupUser, inverse_of: :dedicated_servers

    has_many :events, class_name: Accounts::Event, as: :entity

    validates :account, presence: true
    validates :hostname, hostname: true, presence: true
    validates :amount, presence: true, numericality: { greater_than_or_equal_to: 0 }

    def to_s
      "#{long_id} (#{hostname})"
    end

    def server_type_string
      "Dedicated Server"
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
      end

      def pending_suspension?
        active? && suspend_on.present?
      end

      def pending_termination?
        suspended? && terminate_on.present?
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
      end

      def bill_to(ledger, event_logger)
        with_lock do
          if billable?
            logger.info { "Billing dedicated server #{to_s} to account #{account}"}

            ledger.add_debit(amount, "Dedicated Server #{to_s} from #{next_due} through #{new_next_due - 1.day}")
          end

          event_logger.with_entity(self).log(:server_billed)

          push_next_due!
        end
      end

      def amount_dollars
        amount / 100.0 if amount
      end

      def amount_dollars=(value)
        self.amount = BigDecimal.new(value) * 100 if value.present?
      end

      private
      def billable?
        amount > 0
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

    concerning :Monitoring do
      def monitoring_paused?
        false
      end
    end

    concerning :Patches do
      included do
        scope :find_pending_patches, -> { find_active.where('patch_at <= ? OR patch_out_of_band = ?', Time.zone.today, true) }
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
      TERMINATED_STATES = [:order_cancelled]
      PENDING_STATES = [:pending_confirmation, :order_cancelled]

      included do
        scope :find_active, -> { where(state: :active) }
        scope :find_pending_confirmation, -> { where(state: :pending_confirmation) }
        scope :find_pending_completion, -> { where(state: :pending_completion) }
        scope :find_pending_payment, -> { where(state: :pending_payment) }
        scope :find_pending_provision, -> { where(state: :pending_provision) }
        scope :find_pending_action, -> { where(state: [:pending_approval, :pending_provision, :pending_user_termination, :pending_admin_termination, :pending_automation_termination, :pending_admin_suspension, :pending_automation_suspension]) }
        scope :find_current, -> { where('dedicated_servers.state NOT IN (?)', TERMINATED_STATES) }
        scope :find_conversions, -> { where('state NOT IN (?)', PENDING_STATES) }

        state_machine :state, initial: :pending_confirmation do
          event :confirm do
            transition :pending_confirmation => :pending_approval
          end

          event :cancel_order do
            transition :pending_confirmation => :order_cancelled
          end

          event :approve do
            transition :pending_approval => :pending_billing
          end

          event :billed do
            transition :pending_billing => :pending_payment
          end

          event :paid do
            transition :pending_payment => :pending_provision
          end

          event :provision do
            transition :pending_provision => :active
          end

          event :schedule_automation_suspension do
            transition :active => :pending_automation_suspension
          end

          event :schedule_admin_suspension do
            transition :active => :pending_admin_suspension
          end

          event :suspend do
            transition :pending_automation_suspension => :automation_suspended
            transition :pendin_admin_suspension => :admin_suspended
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

          event :terminate do
            transition :pending_user_termination => :user_terminated
            transition :pending_automation_termination => :automation_terminated
            transition :pending_admin_termination => :admin_terminated
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
        [:pending_billing, :pending_provision, :pending_completion].include? state_name
      end
    end
  end
end