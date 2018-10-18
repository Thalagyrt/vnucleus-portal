class AddUpdatedAtToTickets < ActiveRecord::Migration
  def change
    add_column :tickets, :updated_at, :datetime
    add_index :tickets, :updated_at
  end
end
