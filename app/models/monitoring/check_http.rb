module Monitoring
  class CheckHTTP
    def initialize(check)
      @check = check
    end

    def perform
      begin
        Timeout.timeout(5) do
          http = Net::OverridableHTTP.new(host, port)
          http.override_ip_address = ip_address

          if scheme == 'https'
            http.use_ssl = true
            http.verify_mode = OpenSSL::SSL::VERIFY_NONE
          end

          request = Net::HTTP::Get.new(request_uri)
          request['User-Agent'] = 'vNucleus Monitor Bot'

          response_time = Benchmark.measure {
            @response = http.request(request)
          }.real * 1000.0

          if @response.kind_of? Net::HTTPSuccess
            record_result(response_time: response_time, status_code: :ok, status: @response.code)
          else
            record_result(response_time: response_time, status_code: :critical, status: @response.code)
          end
        end
      rescue => e
        record_result(response_time: 0, status_code: :critical, status: e.message)
      end
    end

    private
    attr_reader :check
    delegate :ip_address, :record_result, to: :check
    delegate :host, :port, :scheme, :request_uri, to: :check_data

    def check_data
      @check_data ||= URI(check.check_data)
    end
  end
end