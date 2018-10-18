module Solus
  class Plan < ActiveRecord::Base
    extend Enumerize

    has_many :servers, inverse_of: :plan
    has_many :plan_templates, inverse_of: :plan
    has_many :templates, through: :plan_templates
    has_many :cluster_plans, inverse_of: :plan
    has_many :clusters, through: :cluster_plans

    validates :name, presence: true
    validates :plan_part, presence: true
    validates :vcpus, presence: true, numericality: { greater_than: 0 }
    validates :ip_addresses, presence: true, numericality: { greater_than: 0 }
    validates :ipv6_addresses, presence: true, numericality: { greater_than: 0 }
    validates :disk, presence: true, numericality: { greater_than: 0 }
    validates :disk_type, presence: true
    validates :ram, presence: true, numericality: { greater_than: 0 }
    validates :transfer, presence: true, numericality: { greater_than: 0 }
    validates :amount, presence: true, numericality: { greater_than: 0 }
    validates :network_out, presence: true, numericality: { greater_than: 0 }

    enumerize :status, in: { active: 1, hidden: 2, admin_only: 3 }, default: :hidden, scope: true
    enumerize :feature_status, in: { not_featured: 1, featured: 2, highlighted: 3 }, default: :not_featured, scope: true

    attr_accessor :highlighted

    scope :active, -> { with_status(:active) }
    scope :not_hidden, -> { without_status(:hidden) }
    scope :featured, -> { with_feature_status(:featured, :highlighted).order('managed ASC, amount ASC') }
    scope :legacy, -> { where(legacy: true) }

    scope :sorted, -> { order('ram ASC, disk ASC') }

    def active?
      status.to_sym == :active
    end

    def admin_only?
      status.to_sym == :admin_only
    end

    def reinstallable?
      !legacy?
    end

    concerning :Featured do
      def highlighted?
        feature_status == 'highlighted'
      end
    end

    concerning :Forms do
      def amount_dollars
        amount / 100.0 if amount
      end

      def amount_dollars=(value)
        self.amount = BigDecimal.new(value) * 100 if value.present?
      end

      def ram_mb
        ram / 1.megabyte if ram
      end

      def ram_mb=(value)
        self.ram = value.to_i * 1.megabyte if value.present?
      end

      def disk_gb
        disk / 1.gigabyte if disk
      end

      def disk_gb=(value)
        self.disk = value.to_i * 1.gigabyte if value.present?
      end

      def transfer_tb
        transfer.to_f / 1.terabyte if transfer
      end

      def transfer_tb=(value)
        self.transfer = value.to_f * 1.terabyte if value.present?
      end
    end

    concerning :Servers do
      def active_servers
        servers.find_active
      end

      def active_server_count
        active_servers.count
      end
    end

    concerning :Stock do
      def stock
        clusters.stock(self)
      end
    end
  end
end