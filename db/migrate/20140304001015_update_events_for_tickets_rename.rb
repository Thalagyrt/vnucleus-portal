class UpdateEventsForTicketsRename < ActiveRecord::Migration
  def up
    execute "UPDATE accounts_events SET entity_type='Tickets::Ticket' WHERE entity_type='Account::Ticket'"
  end

  def down
    execute "UPDATE accounts_events SET entity_type='Account::Ticket' WHERE entity_type='Tickets::Ticket'"
  end
end
