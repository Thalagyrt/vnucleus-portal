module Admin
  module Licenses
    class UsageReportsController < Admin::ApplicationController
      power :admin_license_usages, as: :usages_scope
      power :admin_license_products, as: :products_scope

      decorates_assigned :usage_reports, :usage_report

      def new
        @reference_dates = license_usages_scope.available_reference_dates

        @usage_report_form = ::Licenses::UsageReportForm.new
      end

      def index
        @usage_reports = ::Licenses::UsageReportIndexService.new(usages_scope: usages_scope, products_scope: products_scope).usage_reports
      end

      def show
        @usage_report = ::Licenses::UsageReport.new(usages_scope: usages_scope, products_scope: products_scope, start_date: "#{params[:id]}-01")
      end

      private
      def usage_report_form_params
        params.require(:usage_report_form).permit(:reference_date)
      end
    end
  end
end