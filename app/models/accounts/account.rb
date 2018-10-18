module Accounts
  class Account < ActiveRecord::Base
    include Concerns::LongIdModelConcern
    include PgSearch

    visitable :visit, class_name: Ahoy::Visit

    validates :entity_name, presence: true

    has_many :memberships, dependent: :delete_all, inverse_of: :account
    has_many :transactions, dependent: :delete_all, inverse_of: :account
    has_many :events, dependent: :delete_all, inverse_of: :account
    has_many :invites, dependent: :delete_all, inverse_of: :account
    has_many :notes, dependent: :delete_all, inverse_of: :account
    has_many :tickets, class_name: ::Tickets::Ticket, dependent: :destroy, inverse_of: :account
    has_many :users, class_name: ::Users::User, through: :memberships
    has_many :solus_servers, class_name: ::Solus::Server, dependent: :destroy, inverse_of: :account
    has_many :dedicated_servers, class_name: ::Dedicated::Server, dependent: :destroy, inverse_of: :account
    has_many :licenses, class_name: ::Licenses::License, dependent: :delete_all, inverse_of: :account
    has_many :referrals, class_name: ::Accounts::Account, foreign_key: :referrer_id, inverse_of: :referrer
    belongs_to :referrer, class_name: ::Accounts::Account, inverse_of: :referrals
    has_many :backup_users, dependent: :delete_all, inverse_of: :account
    has_many :monitoring_checks, class_name: ::Monitoring::Check, inverse_of: :account

    serialize :maxmind_response

    pg_search_scope :search,
                    against: { long_id: 'C', name: 'A' },
                    associated_against: {
                        users: { email: 'C', first_name: 'B', last_name: 'B' },
                    },
                    using: {
                        tsearch: {
                            prefix: true,
                            dictionary: 'english'
                        }
                    }

    def to_s
      "#{long_id} (#{name})"
    end

    concerning :Affiliates do
      def referral_count
        referrals.count
      end

      def referral_income
        -transactions.find_referrals.total
      end

      def credit_referrals(batch)
        referrals.each do |referral|
          if referral.monthly_rate > 0
            payout_amount = referral.monthly_rate * affiliate_recurring_factor

            logger.info { "Adding #{MoneyFormatter.format_amount(payout_amount)} referral credit to account #{self}"}

            batch.add_referral(payout_amount, "Monthly Commission (#{referral.long_id})")
          end
        end
      end

      private
      def affiliate_recurring_factor
        Rails.application.config.affiliate_recurring_factor
      end
    end

    concerning :Billing do
      included do
        scope :with_expiring_credit_card, -> { where('stripe_expiration_date < ?', Time.zone.today + 3.months).where('stripe_expiration_date > ?', Time.zone.today) }
        scope :with_expired_credit_card, -> { where('stripe_expiration_date < ?', Time.zone.today).where(stripe_valid: true) }
        scope :with_valid_credit_card, -> { where('stripe_id IS NOT NULL').where(stripe_valid: true).where('stripe_expiration_date > ?', Time.zone.today) }
        scope :with_balance_owed, -> { joins(:transactions).group('accounts_accounts.id').having('sum(amount) >= 100') }

        before_create :set_next_due
      end

      def bill_services(batch, event_logger)
        logger.info { "Billing account #{self} services" }

        bill_solus_servers(batch, event_logger)
        bill_dedicated_servers(batch, event_logger)
        bill_licenses(batch, event_logger)

        if due?
          if affiliate_enabled?
            credit_referrals(batch)
          end

          push_next_due!
        end
      end

      def total_income
        -transactions.where(category: 'payment').total
      end

      def balance
        read_attribute(:balance) || transactions.total
      end

      def balance_favorable?
        balance < 100
      end

      def balance_owed?
        !balance_favorable?
      end

      def monthly_rate
        billable_solus_servers.monthly_rate + billable_dedicated_servers.monthly_rate + billable_licenses.monthly_rate
      end

      def credit_card_valid?
        stripe_id.present? && stripe_valid? && stripe_expiration_date > Time.zone.today
      end

      def credit_card_invalid?
        !credit_card_valid?
      end

      def credit_card_expiring?
        stripe_expiration_date && stripe_expiration_date < (Time.zone.today + 3.months) && stripe_expiration_date > Time.zone.today
      end

      def add_debit(amount, description)
        transactions.create(amount: amount, description: description, reference: "db_#{StringGenerator.reference}", category: 'debit')
      end

      def add_refund(amount, description)
        transactions.create(amount: amount, description: description, reference: "rf_#{StringGenerator.reference}", category: 'refund')
      end

      def add_credit(amount, description)
        transactions.create(amount: -amount, description: description, reference: "cr_#{StringGenerator.reference}", category: 'credit')
      end

      def add_referral(amount, description)
        transactions.create(amount: -amount, description: description, reference: "re_#{StringGenerator.reference}", category: 'referral')
      end

      def add_payment(amount, fee, credit_card, reference)
        transactions.create(amount: -amount, description: "Payment via #{credit_card.to_s}", reference: reference, category: 'payment', fee: fee)
      end

      def credit_card_defaults
        {
            address_line1: address_line1,
            address_line2: address_line2,
            address_city: address_city,
            address_state: address_state,
            address_zip: address_zip,
            address_country: address_country,
        }
      end

      def due?
        next_due <= Time.zone.today
      end

      def push_next_due
        self.next_due = new_next_due
      end

      def push_next_due!
        push_next_due
        save!
      end

      private
      def new_next_due
        Time.zone.today.next_month.at_beginning_of_month
      end

      def set_next_due
        self.next_due ||= Time.zone.today.next_month.at_beginning_of_month
      end
    end

    concerning :Caches do
      def update_balance_cache!
        self.balance_cache = balance
        save!
      end

      def update_monthly_rate_cache!
        self.monthly_rate_cache = monthly_rate
        save!
      end

      def update_server_count_cache!
        self.server_count_cache = server_count
        save!
      end
    end

    concerning :DedicatedServers do
      def bill_dedicated_servers(batch, event_logger)
        due_dedicated_servers.each do |server|
          server.bill_to(batch, event_logger)
        end
      end

      def dedicated_server_count
        current_dedicated_servers.count
      end

      def due_dedicated_servers
        dedicated_servers.find_due
      end

      def pending_dedicated_servers
        dedicated_servers.find_pending_confirmation
      end

      def current_dedicated_servers
        dedicated_servers.find_current
      end

      def billable_dedicated_servers
        dedicated_servers.find_billable
      end

      def dedicated_servers_pending_payment
        dedicated_servers.find_pending_payment
      end

      def dedicated_servers_pending_provision
        dedicated_servers.find_pending_provision
      end
    end

    concerning :LegacyServices do
      def has_legacy_solus_servers?
        legacy_solus_server_count > 0
      end

      def legacy_solus_server_count
        solus_servers.find_current.find_legacy.count
      end
    end

    concerning :Licenses do
      def bill_licenses(batch, event_logger)
        due_licenses.each do |license|
          license.bill_to(batch, event_logger)
        end
      end

      def due_licenses
        billable_licenses.find_due
      end

      def billable_licenses
        licenses
      end

      def license_count
        licenses.count
      end
    end

    concerning :Memberships do
      def membership_count
        memberships.count
      end
    end

    concerning :Monitoring do
      def monitoring_check_count
        monitoring_checks.count
      end
    end

    concerning :Names do
      included do
        before_save :update_name
      end

      def update_name
        if nickname.present?
          self.name = "#{entity_name} - #{nickname}"
        else
          self.name = entity_name
        end
      end
    end

    concerning :Servers do
      def pending_first_server?
        solus_servers.count == 0 && dedicated_servers.count == 0
      end

      def server_count
        solus_server_count + dedicated_server_count
      end
    end

    concerning :SolusServers do
      def bill_solus_servers(batch, event_logger)
        due_solus_servers.each do |server|
          server.bill_to(batch, event_logger)
        end
      end

      def solus_server_count
        current_solus_servers.count
      end

      def total_ram
        current_solus_servers.includes(:plan).inject(0) { |v, s| v + s.ram }
      end

      def total_disk
        current_solus_servers.includes(:plan).inject(0) { |v, s| v + s.disk }
      end

      def due_solus_servers
        solus_servers.find_due
      end

      def pending_solus_servers
        solus_servers.find_pending_confirmation
      end

      def current_solus_servers
        solus_servers.find_current
      end

      def billable_solus_servers
        solus_servers.find_billable
      end

      def automation_suspended_solus_servers
        solus_servers.find_automation_suspended
      end

      def solus_servers_pending_payment
        solus_servers.find_pending_payment
      end

      def solus_servers_pending_provision
        solus_servers.find_pending_provision
      end
    end

    concerning :State do
      included do
        state_machine :state, initial: :pending_billing_information do
          event :billing_information_entered do
            transition :pending_billing_information => :pending_activation
          end

          event :activate do
            transition :pending_activation => :active
          end

          event :reject do
            transition [:pending_billing_information, :pending_activation, :active] => :rejected
          end

          event :close do
            transition :active => :closed
          end
        end

        scope :find_active, -> { where(state: :active) }
        scope :find_current, -> { where(state: [:active, :pending_billing_information, :pending_activation]) }
        scope :find_pending_activation, -> { where(state: :pending_activation) }
      end

      def current?
        ['active', 'pending_billing_information', 'pending_activation'].include? state.to_s
      end
    end

    concerning :Tickets do
      def open_tickets
        tickets.find_open
      end

      def open_tickets_count
        open_tickets.count
      end

      def tickets_awaiting_client_action
        tickets.find_awaiting_client_action
      end

      def tickets_awaiting_client_action_count
        tickets_awaiting_client_action.count
      end

      def tickets_awaiting_staff_action
        tickets.find_awaiting_staff_action
      end

      def tickets_awaiting_staff_action_count
        tickets_awaiting_staff_action.count
      end
    end

    concerning :Welcomes do
      included do
        state_machine :welcome_state, initial: :pending, namespace: :welcome do
          event :complete do
            transition :pending => :complete
          end
        end

        scope :find_pending_welcome, -> { where(welcome_state: :pending) }
      end
    end
  end
end