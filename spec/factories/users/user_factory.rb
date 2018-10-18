FactoryGirl.define do
  factory :user, class: Users::User do
    sequence(:email) { |n| "user#{n}@test.betaforce.com" }
    password { StringGenerator.password }
    password_confirmation { |u| u.password }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    security_question 'Foobar?'
    security_answer 'Snafu!'
    phone { '3108675309' }
    legal_accepted true
    profile_complete true
    enhanced_security false

    after(:create) do |instance|
      instance.update_attributes email_confirmed: true
    end

    factory :staff_user do
      is_staff { true }
      otp_secret { ROTP::Base32.random_base32 }
    end

    factory :user_with_account do
      after(:create) do |instance|
        account = FactoryGirl.create(:account)

        instance.account_memberships.create(account: account, roles: [:full_control])
      end
    end
  end
end