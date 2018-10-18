class RenameAccountTicketsToTicketsTickets < ActiveRecord::Migration
  def up
    rename_table :account_tickets, :tickets_tickets
  end

  def down
    rename_table :tickets_tickets, :account_tickets
  end
end
