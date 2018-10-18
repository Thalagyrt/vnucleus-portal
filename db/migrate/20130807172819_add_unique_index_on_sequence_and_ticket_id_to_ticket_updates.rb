class AddUniqueIndexOnSequenceAndTicketIdToTicketUpdates < ActiveRecord::Migration
  def change
    add_index :ticket_updates, [:sequence, :ticket_id], unique: true
  end
end
