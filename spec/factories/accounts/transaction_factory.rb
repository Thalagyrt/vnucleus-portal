FactoryGirl.define do
  factory :transaction, class: Accounts::Transaction do
    sequence(:description) { |n| "Transaction ##{n}" }
    reference { StringGenerator.reference }
    amount 995
    category 'debit'
    account

    factory :transaction_payment do
      sequence(:description) { |n| "Payment ##{n}" }
      amount -995
      category 'payment'
    end
  end
end