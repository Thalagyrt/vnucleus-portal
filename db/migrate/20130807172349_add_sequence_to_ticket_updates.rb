class AddSequenceToTicketUpdates < ActiveRecord::Migration
  def change
    add_column :ticket_updates, :sequence, :integer
  end
end
