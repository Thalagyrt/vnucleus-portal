class DropAccountCreditsDebitsPayments < ActiveRecord::Migration
  def change
    drop_table :account_credits
    drop_table :account_debits
    drop_table :account_payments
  end
end
