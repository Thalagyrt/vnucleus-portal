FactoryGirl.define do
  factory :ticket_update, class: Tickets::Update do
    sequence(:body) { |n| "Update ##{n}" }
    user
  end
end