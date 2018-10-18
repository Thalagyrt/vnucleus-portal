FactoryGirl.define do
  factory :account, class: Accounts::Account do
    sequence(:entity_name) { |n| "Account ##{n}" }
    sequence(:stripe_id) { |n| "cus_#{n}"}
    stripe_valid { true }
    stripe_expiration_date { Time.zone.today + 2.years }
    state { 'active' }
    welcome_state { 'complete' }
  end
end