class FixTicketsInEvents < ActiveRecord::Migration
  def up
    execute "UPDATE account_events SET entity_type='Account::Ticket' WHERE entity_type='Ticket'"
  end

  def down
    execute "UPDATE account_events SET entity_type='Ticket' WHERE entity_type='Account::Ticket'"
  end
end
