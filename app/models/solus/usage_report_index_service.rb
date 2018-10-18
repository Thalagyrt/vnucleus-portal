module Solus
  class UsageReportIndexService
    def initialize(opts = {})
      @usages_scope = opts.fetch(:usages_scope)
      @usage_report_class = opts.fetch(:usage_report_class) { UsageReport }
    end

    def usage_reports
      dates.map { |d| usage_report_class.new(usages_scope: usages_scope, start_date: d) }
    end

    private
    attr_reader :usages_scope, :usage_report_class

    def dates
      (minimum_date..maximum_date).select { |d| d.day == 1 }
    end

    def minimum_date
      usages_scope.minimum(:created_at).to_date.at_beginning_of_month
    end

    def maximum_date
      usages_scope.maximum(:created_at).to_date.at_beginning_of_month
    end
  end
end