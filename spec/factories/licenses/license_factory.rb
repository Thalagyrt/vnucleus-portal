FactoryGirl.define do
  factory :license, class: Licenses::License do
    count  { 1 }
    product { create :license_product }
  end

  factory :license_product, class: Licenses::Product do
    sequence(:description) { |n| "License ##{n}" }
    sequence(:product_code) { |n| "#{n}" }

    amount { 500 }
  end
end