class RenameAccountTicketUpdatesToTicketsUpdates < ActiveRecord::Migration
  def up
    rename_table :account_ticket_updates, :tickets_updates
  end

  def down
    rename_table :tickets_updates, :account_ticket_updates
  end
end
