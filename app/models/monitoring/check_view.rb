module Monitoring
  class CheckView
    include Draper::Decoratable

    def initialize(opts = {})
      @check = opts.fetch(:check)
      @start = opts.fetch(:start)
      @finish = opts.fetch(:finish)
    end

    attr_reader :check, :start, :finish

    def performance_metric_report
      @performance_metric_report ||= PerformanceMetricReport.new(check: check, start: start, finish: finish).report
    end

    def response_time_report
      @response_time_report ||= ResponseTimeReport.new(check: check, start: start, finish: finish)
    end
  end
end