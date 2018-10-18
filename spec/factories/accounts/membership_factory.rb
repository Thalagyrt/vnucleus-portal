FactoryGirl.define do
  factory :membership, class: Accounts::Membership do
    account { create :account }
    user { create :user }
    roles [:full_control]
  end
end