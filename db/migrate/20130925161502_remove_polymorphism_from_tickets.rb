class RemovePolymorphismFromTickets < ActiveRecord::Migration
  def change
    remove_column :tickets, :parent_type
    rename_column :tickets, :parent_id, :account_id
  end
end
