class AddStatusToTicketUpdates < ActiveRecord::Migration
  def change
    add_column :ticket_updates, :status, :integer
  end
end
