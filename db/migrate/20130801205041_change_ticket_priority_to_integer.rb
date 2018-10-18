class ChangeTicketPriorityToInteger < ActiveRecord::Migration
  def change
    remove_column :tickets, :priority
    add_column :tickets, :priority, :integer
    add_index :tickets, :priority
  end
end
