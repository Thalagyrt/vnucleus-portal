module Monitoring
  class PerformanceMetricChart
    def initialize(key, metrics)
      @key = key
      @metrics = metrics
    end

    attr_reader :key

    def anchor_key
      key.hash.to_s
    end

    def data
      @data ||= metrics.order('monitoring_results.created_at ASC').pluck('monitoring_results.created_at', 'monitoring_performance_metrics.value')
    end

    def warn
      last_metric.warn
    end

    def crit
      last_metric.crit
    end

    def min
      minmax[0]
    end

    def max
      minmax[1]
    end

    def js_data
      @js_data ||= data.map { |k, v| [k.to_i * 1000, v.to_f] }
    end

    private
    attr_reader :metrics

    def last_metric
      @last_metric ||= metrics.last
    end

    def minmax
      @minmax ||= metrics.pluck('MIN(LEAST(value, min))', 'MAX(GREATEST(value, crit, warn, max))').first
    end
  end
end