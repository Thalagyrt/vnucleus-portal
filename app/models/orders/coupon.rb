module Orders
  class Coupon < ActiveRecord::Base
    extend Enumerize

    validates :coupon_code, presence: true, uniqueness: true
    validates :factor, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 1 }
    enumerize :status, in: { active: 1, hidden: 2 }, default: :hidden, scope: true

    scope :find_active, -> {
      with_status(:active).
          where('expires_at IS NULL OR expires_at >= ?', Time.zone.now).
          where('begins_at IS NULL OR begins_at <= ?', Time.zone.now)
    }
    scope :find_published, -> { where(published: true) }

    scope :sorted, -> { order('factor ASC') }

    class << self
      def fetch(coupon_code)
        find_active.find_by(coupon_code: coupon_code.downcase) || Orders::NullCoupon.new
      end
    end
    
    def apply(service)
      service.plan_amount = apply_to_plan_amount(service.plan_amount)
      service.coupon = self
    end

    def apply_to_plan_amount(amount)
      amount * factor
    end

    def apply_to_template_amount(amount)
      amount
    end
    
    def coupon_code=(coupon_code)
      super(coupon_code.downcase)
    end
  end
end