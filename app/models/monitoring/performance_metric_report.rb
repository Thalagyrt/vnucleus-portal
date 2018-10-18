module Monitoring
  class PerformanceMetricReport
    def initialize(opts = {})
      @check = opts.fetch(:check)
      @start = opts.fetch(:start) { Time.zone.now - 24.hours }
      @finish = opts.fetch(:finish) { Time.zone.now }
    end

    def report
      @report ||= keys.sort.map { |key| PerformanceMetricChart.new(key, performance_metrics.where(key: key)) }
    end

    private
    attr_reader :check, :start, :finish

    def keys
      @keys ||= performance_metrics.uniq.pluck(:key)
    end

    def performance_metrics
      check.performance_metrics.joins(:result).where(monitoring_results: { created_at: start..finish })
    end
  end
end