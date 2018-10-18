module Solus
  class ServerCreator
    include Wisper::Publisher

    def initialize(opts = {})
      @account = opts.fetch(:account)
      @server_factory = opts.fetch(:server_factory) { account.solus_servers }
    end

    def create(params)
      @server_form = ServerForm.new(params)

      if server_form.valid?
        @server = server_factory.new(server_form.server_params)

        apply_plan
        apply_template
        apply_coupon
        set_billing_cycle

        return publish(:create_success, server) if server.save
      end

      publish(:create_failure, server_form)
    end

    private
    attr_reader :account, :server_factory, :server, :server_form

    def set_billing_cycle
      server.next_due = (Time.zone.today + 7.days).next_month.at_beginning_of_month
    end

    def apply_plan
      server.transfer = server.plan.transfer
      server.disk = server.plan.disk
      server.plan_amount = server.plan.amount
    end

    def apply_template
      server.template_amount = server.template.amount
    end

    def apply_coupon
      coupon = find_coupon(server_form.coupon_code)
      coupon.apply(server)
    end

    def find_coupon(coupon_code)
      ::Orders::Coupon.fetch(coupon_code)
    end
  end
end