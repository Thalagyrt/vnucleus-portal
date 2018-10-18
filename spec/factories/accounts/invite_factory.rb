FactoryGirl.define do
  factory :invite, class: Accounts::Invite do
    sequence(:email) { |n| "user#{n}@test.betaforce.com" }
    account { create :account }
    roles { [:full_control] }
  end
end