require 'open3'

module Monitoring
  class CheckICMP
    def initialize(check)
      @check = check
    end

    def perform
      begin
        Timeout.timeout(5) do
          response_time = ping

          if response_time
            record_result(response_time: response_time, status_code: :ok)
          else
            record_result(response_time: 0, status_code: :critical)
          end
        end
      rescue
        record_result(response_time: 0, status_code: :critical)
      end
    end

    private
    attr_reader :check
    delegate :ip_address, :record_result, to: :check

    def ping
      cmd = ['ping', '-c 1', ip_address].join(' ')

      ::Open3.popen3(cmd) { |_, stdout, _, wait_thr|
        return false unless wait_thr.value.success?

        /time=(\d+.\d+) ms/.match(stdout.read)[1].to_f
      }
    end
  end
end