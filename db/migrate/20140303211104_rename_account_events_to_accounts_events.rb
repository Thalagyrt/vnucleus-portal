class RenameAccountEventsToAccountsEvents < ActiveRecord::Migration
  def up
    rename_table :account_events, :accounts_events
  end

  def down
    rename_table :accounts_events, :account_events
  end
end
