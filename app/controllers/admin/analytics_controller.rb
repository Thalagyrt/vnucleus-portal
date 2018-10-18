module Admin
  class AnalyticsController < Admin::ApplicationController
    power :admin_solus_servers, as: :solus_servers_scope
    power :admin_visits, as: :visits_scope

    decorates_assigned :analytics

    def show
      @analytics = Analytics.new(solus_servers: solus_servers_scope, visits: visits_scope)
    end
  end
end