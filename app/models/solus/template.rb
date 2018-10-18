module Solus
  class Template < ActiveRecord::Base
    extend Enumerize

    validates :name, presence: true
    validates :plan_part, presence: true
    validates :template, presence: true
    validates :virtualization_type, presence: true
    validates :root_username, presence: true

    has_many :plan_templates, inverse_of: :template
    has_many :plans, through: :plan_templates

    has_many :install_times, inverse_of: :template
    has_many :usages

    has_many :servers

    enumerize :status, in: { active: 1, hidden: 2 }, default: :hidden, scope: true
    enumerize :category, in: { none: 1, cpanel: 2 }, default: :none

    scope :active, -> { with_status(:active) }

    scope :sorted, -> { order('name DESC') }

    scope :with_active_servers, -> { joins(:servers).merge(Server.find_active).uniq }

    def to_s
      name
    end

    def detailed_to_s
      "#{virtualization_type}: #{name} (#{id})"
    end

    concerning :Categories do
      def is_cpanel?
        category == 'cpanel'
      end
    end

    concerning :Forms do
      def amount_dollars
        amount / 100.0 if amount
      end

      def amount_dollars=(value)
        self.amount = BigDecimal.new(value) * 100 if value.present?
      end


      def minimum_ram_mb
        minimum_ram / 1.megabyte if minimum_ram
      end

      def minimum_ram_mb=(value)
        self.minimum_ram = value.to_i * 1.megabyte if value.present?
      end

      def minimum_disk_gb
        minimum_disk / 1.gigabyte if minimum_disk
      end

      def minimum_disk_gb=(value)
        self.minimum_disk = value.to_i * 1.gigabyte if value.present?
      end
    end

    concerning :Installs do
      included do
        delegate :install_time, to: :install_times
      end

      def log_install_time(seconds)
        install_times.log_install_time(seconds)
      end
    end
  end
end