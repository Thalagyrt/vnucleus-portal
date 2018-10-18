FactoryGirl.define do
  factory :ticket, class: Tickets::Ticket do
    sequence(:subject) { |n| "Ticket ##{n}" }
    account { create :account }
  end
end