class AddPriorityToTicketUpdates < ActiveRecord::Migration
  def change
    add_column :ticket_updates, :priority, :integer
  end
end
