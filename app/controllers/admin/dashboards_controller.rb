module Admin
  class DashboardsController < Admin::ApplicationController
    decorates_assigned :dashboard

    power :admin_tickets, as: :tickets_scope
    power :admin_transactions, as: :transactions_scope
    power :admin_solus_servers, as: :solus_servers_scope
    power :admin_solus_clusters, as: :solus_clusters_scope
    power :admin_accounts, as: :accounts_scope
    power :admin_users, as: :users_scope
    power :admin_licenses, as: :licenses_scope
    power :admin_dedicated_servers, as: :dedicated_servers_scope

    def show
      @dashboard = Dashboard.new(
          tickets: tickets_scope.includes(:account),
          transactions: transactions_scope,
          solus_servers: solus_servers_scope,
          solus_clusters: solus_clusters_scope,
          accounts: accounts_scope,
          users: users_scope,
          licenses: licenses_scope,
          dedicated_servers: dedicated_servers_scope,
      )
    end
  end
end