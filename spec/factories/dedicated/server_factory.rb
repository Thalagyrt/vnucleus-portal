FactoryGirl.define do
  factory :dedicated_server, class: Dedicated::Server do
    sequence(:hostname) { |n| "server#{n}.test.betaforce.com" }
    account { create :account }
    amount 995
    next_due { Time.zone.today.next_month.at_beginning_of_month }
  end
end