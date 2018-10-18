class UpdateAccountEventsForTransactionNamespace < ActiveRecord::Migration
  def up
    execute "UPDATE account_events SET entity_type='Accounts::Transaction' WHERE entity_type='Account::Transaction'"
  end

  def down
    execute "UPDATE account_events SET entity_type='Account::Transaction' WHERE entity_type='Accounts::Transaction'"
  end
end
