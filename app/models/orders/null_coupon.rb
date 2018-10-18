module Orders
  class NullCoupon
    include ActiveModel::Model

    def apply(_); end

    def apply_to_plan_amount(amount)
      amount
    end

    def apply_to_template_amount(amount)
      amount
    end
  end
end