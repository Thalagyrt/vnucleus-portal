module Solus
  class CouponsController < ::ApplicationController
    decorates_assigned :plans

    def show
      coupon = ::Orders::Coupon.fetch(params[:coupon_code])

      plan_amount = coupon.apply_to_plan_amount(params[:plan_amount].to_i).to_i
      template_amount = coupon.apply_to_template_amount(params[:template_amount].to_i).to_i

      render json: { plan_amount: plan_amount, template_amount: template_amount }
    end
  end
end