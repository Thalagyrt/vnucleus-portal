module Admin
  module Solus
    class UsageReportsController < Admin::ApplicationController
      power :admin_solus_usages, as: :usages_scope

      decorates_assigned :usage_reports, :usage_report

      def index
        @usage_reports = ::Solus::UsageReportIndexService.new(usages_scope: usages_scope).usage_reports
      end

      def show
        @usage_report = ::Solus::UsageReport.new(usages_scope: usages_scope, start_date: "#{params[:id]}-01")
      end
    end
  end
end