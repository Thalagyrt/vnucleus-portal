module Monitoring
  class CheckSSLValidity
    def initialize(check)
      @check = check
    end

    def perform
      begin
        response_time = Benchmark.measure {
          @raw_socket = Timeout.timeout(5, Net::OpenTimeout) do
            TCPSocket.open(ip_address, port)
          end

          ssl_context = OpenSSL::SSL::SSLContext.new
          socket = OpenSSL::SSL::SSLSocket.new(@raw_socket, ssl_context)

          socket.hostname = host

          socket.connect
          socket.post_connection_check(host)

          @certificate = socket.peer_cert
        }.real * 1000.0

        not_after = @certificate.not_after
        days_remaining = (not_after - Time.zone.now) / 1.day

        if days_remaining < 0
          record_result(response_time: response_time, status_code: :critical, status: "Certificate is expired!")
        elsif days_remaining < 3
          record_result(response_time: response_time, status_code: :critical, status: "Certificate expires in #{days_remaining.to_i} days.")
        elsif days_remaining < 30
          record_result(response_time: response_time, status_code: :warning, status: "Certificate expires in #{days_remaining.to_i} days.")
        else
          record_result(response_time: response_time, status_code: :ok, status: "Certificate expires in #{days_remaining.to_i} days.")
        end
      rescue => e
        record_result(response_time: 0, status_code: :critical, status: e.message)
      ensure
        if @raw_socket.present?
          @raw_socket.close unless @raw_socket.closed?
        end
      end
    end

    private
    attr_reader :check
    delegate :ip_address, :record_result, to: :check
    delegate :host, :port, to: :check_data

    def check_data
      @check_data ||= URI(check.check_data)
    end
  end
end