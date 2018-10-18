class RenameTicketsIntoAccounts < ActiveRecord::Migration
  def change
    rename_table :tickets, :account_tickets
    rename_table :ticket_updates, :account_ticket_updates
  end
end
