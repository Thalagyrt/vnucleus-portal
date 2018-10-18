module Solus
  class CreditingServerTerminator
    include Wisper::Publisher

    def initialize(opts = {})
      @server = opts.fetch(:server)
      @user = opts[:user]
      @event_logger = opts.fetch(:event_logger) { ::Accounts::EventLogger.new(account: account) }
      @credit_service = opts.fetch(:credit_service) { ::Accounts::CreditService.new(account: account) }
      @server_terminator = opts.fetch(:server_terminator) { ServerTerminator.new(server: server, event_logger: event_logger, user: user) }
    end

    def terminate(params)
      server_terminator.on(:terminate_success) do
        apply_final_credit
        publish(:terminate_success)
      end

      server_terminator.terminate(params)
    end

    private
    attr_reader :server, :user, :event_logger, :credit_service, :server_terminator
    delegate :account, to: :server

    def apply_final_credit
      refund_amount = server.prorated_amount

      if refund_amount > 0
        Rails.logger.info { "Adding prorated termination credit of #{MoneyFormatter.format_amount(refund_amount)} to account #{account}" }

        credit_service.add_credit(refund_amount, "Server #{server.to_s} prorated to #{server.next_due} (Termination Credit)")
      end
    end
  end
end