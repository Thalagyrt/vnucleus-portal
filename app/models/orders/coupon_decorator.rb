module Orders
  class CouponDecorator < ApplicationDecorator
    delegate_all

    def render_coupon_code
      coupon_code.upcase
    end

    def render_percent
      "#{((1 - factor) * 100).to_i}%"
    end

    def render_expires_at
      expires_at.strftime('%B %e, %Y')
    end
  end
end