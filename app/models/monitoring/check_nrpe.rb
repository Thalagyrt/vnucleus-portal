module Monitoring
  class CheckNRPE
    def initialize(check)
      @check = check
    end

    def perform
      begin
        Timeout.timeout(5) do
          response_time = Benchmark.measure do
            client = Nrpeclient::CheckNrpe.new(host: ip_address, ssl: true,
                                               ssl_cert: Rails.application.config.nrpe[:ssl_cert],
                                               ssl_key: Rails.application.config.nrpe[:ssl_key])
            response = client.send_command(check_data)

            result = response.buffer.split("|")

            @status = result[0]
            @status_code = response.result_code
            @performance_data = result[1]
          end.real * 1000.0

          result = record_result(response_time: response_time, status_code: @status_code, status: @status)

          return unless @performance_data.present?

          @performance_data.split(" ").each do |part|
            key, value = part.split("=")
            split = value.split(";")
            value = split[0].to_f
            warn = split[1].to_f
            crit = split[2].to_f

            # We don't actually use min/max, but let's store them anyway.
            min = split[3].to_f
            max = split[4].to_f

            result.performance_metrics.create!(key: key, value: value, warn: warn, crit: crit, min: min, max: max)
          end
        end
      rescue => e
        record_result(response_time: 0, status_code: :critical, status: e.message)
      end
    end

    private
    attr_reader :check
    delegate :ip_address, :check_data, :record_result, to: :check
  end
end