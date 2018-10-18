module Admin
  class Dashboard
    include ActiveModel::Model
    include Draper::Decoratable

    attr_reader :tickets, :transactions, :solus_servers, :solus_clusters, :accounts, :users, :licenses, :dedicated_servers

    def initialize(opts = {})
      @tickets = opts.fetch(:tickets)
      @transactions = opts.fetch(:transactions)
      @solus_servers = opts.fetch(:solus_servers)
      @solus_clusters = opts.fetch(:solus_clusters)
      @accounts = opts.fetch(:accounts)
      @users = opts.fetch(:users)
      @licenses = opts.fetch(:licenses)
      @dedicated_servers = opts.fetch(:dedicated_servers)
    end

    concerning :Accounts do
      def accounts_pending_welcome
        accounts.find_pending_welcome.find_active.joins(:users).
            merge(::Users::User.find_email_confirmed).uniq.select { |account| account.monthly_rate > 0 }
      end

      def accounts_pending_welcome?
        accounts_pending_welcome.present?
      end

      def accounts_pending_activation
        accounts.find_pending_activation
      end

      def accounts_pending_activation?
        accounts_pending_activation.present?
      end

      def accounts_with_balance_owed
        accounts.find_active.with_balance_owed
      end

      def accounts_with_balance_owed?
        accounts_with_balance_owed.present?
      end

      def open_tickets
        tickets.find_open
      end

      def open_tickets?
        open_tickets.present?
      end

      def current_solus_servers
        solus_servers.find_current.count
      end

      def current_dedicated_servers
        dedicated_servers.find_current.count
      end
    end

    concerning :DedicatedServers do
      def dedicated_servers_pending_action
        dedicated_servers.find_pending_action
      end

      def dedicated_servers_pending_action?
        dedicated_servers_pending_action.present?
      end
    end

    concerning :NodeHealth do
      def solus_clusters?
        solus_clusters.present?
      end

      def available_ram
        solus_clusters.to_a.sum(&:available_ram)
      end

      def ram_limit
        solus_clusters.to_a.sum(&:ram_limit)
      end

      def used_ram
        ram_limit - available_ram
      end

      def ram_utilization
        (used_ram / ram_limit * 100).to_i
      end

      def available_disk
        solus_clusters.to_a.sum(&:available_disk)
      end

      def disk_limit
        solus_clusters.to_a.sum(&:disk_limit)
      end

      def used_disk
        disk_limit - available_disk
      end

      def disk_utilization
        (used_disk / disk_limit * 100).to_i
      end
    end

    concerning :Financials do
      def income_this_year
        -payments.find_in_year(Time.zone.today.year).total
      end

      def fees_this_year
        payments.find_in_year(Time.zone.today.year).fees
      end

      def monthly_rate
        solus_servers.find_active.monthly_rate + dedicated_servers.find_active.monthly_rate + licenses.monthly_rate
      end

      private
      def payments
        transactions.find_payments
      end
    end

    concerning :Patches do
      def servers_pending_patches
        solus_servers.find_pending_patches.includes(:account)
      end

      def servers_pending_patches?
        servers_pending_patches.present?
      end
    end

    concerning :Users do
      def online_users
        users.find_online
      end
    end
  end
end