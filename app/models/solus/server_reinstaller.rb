module Solus
  class ServerReinstaller
    include Wisper::Publisher

    def initialize(opts = {})
      @server = opts.fetch(:server)
      @account_event_logger = opts.fetch(:account_event_logger)
    end

    def reinstall(params)
      @reinstall_form = ReinstallForm.new(params.merge(server: server))

      if reinstall_form.valid?
        prorated_difference = server.prorated_template_difference(reinstall_form.template)

        if server.update_attributes(server_params) && server.schedule_reinstall
          if prorated_difference > 0
            account.add_debit(prorated_difference, "Change server #{server.to_s} operating system to #{server.template.name}")
          elsif prorated_difference < 0
            account.add_credit(-prorated_difference, "Change server #{server.to_s} operating system to #{server.template.name}")
          end

          account_event_logger.with_category(:event).with_entity(@server).log(:server_reinstall_requested)
          Delayed::Job.enqueue ::Solus::ServerReinstallTerminationJob.new(server: @server)
          ::Accounts::PaymentService.new(account: account, event_logger: account_event_logger).charge_balance

          return publish(:reinstall_success)
        end
      end

      publish(:reinstall_failure, reinstall_form)
    end

    private
    attr_reader :server, :reinstall_form, :account_event_logger
    delegate :account, to: :server

    def server_params
      reinstall_form.server_params.merge(template_amount: reinstall_form.template.amount)
    end
  end
end