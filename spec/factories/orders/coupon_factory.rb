FactoryGirl.define do
  factory :coupon, class: Orders::Coupon do
    sequence(:coupon_code) { |n| "coupon#{n}" }
    factor 0.9
    status :active
  end
end