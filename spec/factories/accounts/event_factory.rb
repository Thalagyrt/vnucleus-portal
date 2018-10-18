FactoryGirl.define do
  factory :event, class: Accounts::Event do
    sequence(:message) { |n| "Event ##{n}" }
    user { create :user }

    factory :event_server do
      entity { create :solus_server }
    end

    factory :event_transaction do
      entity { create :transaction }
    end

    factory :event_ticket do
      entity { create :ticket }
    end

    factory :event_invite do
      entity { create :invite }
    end
  end
end