module Monitoring
  class ResponseTimeReport
    def initialize(opts = {})
      @check = opts.fetch(:check)
      @start = opts.fetch(:start) { Time.zone.now - 24.hours }
      @finish = opts.fetch(:finish) { Time.zone.now }
    end

    def min
      0
    end

    def max
      @max ||= (results.maximum(:response_time) || 0) * 1.10
    end

    def data
      @data ||= results.pluck(:created_at, :response_time)
    end

    def js_data
      @js_data ||= data.map { |k, v| [k.to_i * 1000, v.to_f] }
    end

    def regions
      return @regions unless @regions.nil?

      data = results.all

      return [] unless data.present?

      last = nil
      filtered_results = data.select { |result|
        ret = result.status_code != last
        last = result.status_code
        ret
      }

      filtered_results << data.last

      regions = []

      filtered_results.each_cons(2) do |results|
        regions << [results[0].created_at, results[1].created_at, results[0].status_code]
      end

      @regions = regions
    end

    private
    attr_reader :check, :start, :finish

    def results
      check.results.order('created_at ASC').where(created_at: start..finish)
    end
  end
end