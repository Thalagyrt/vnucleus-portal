module Monitoring
  class CheckTCP
    def initialize(check)
      @check = check
    end

    def perform
      begin
        Timeout.timeout(5) do
          @response_time = Benchmark.measure {
            @socket = TCPSocket.open(ip_address, check_data.to_i)
          }.real * 1000.0
        end

        record_result(response_time: @response_time, status_code: :ok)
      rescue => e
        record_result(response_time: 0, status_code: :critical, status: e.message)
      ensure
        if @socket.present?
          @socket.close unless @socket.closed?
        end
      end
    end

    private
    attr_reader :check
    delegate :ip_address, :check_data, :record_result, to: :check
  end
end