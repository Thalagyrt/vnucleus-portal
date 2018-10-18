class ChangeTicketAccountToParent < ActiveRecord::Migration
  def up
    rename_column :tickets, :account_id, :parent_id
    add_column :tickets, :parent_type, :string
    execute "update tickets set parent_type='Account'"

    add_index :tickets, :parent_type
  end

  def down
    remove_index :tickets, :parent_type

    remove_column :tickets, :parent_type
    rename_column :tickets, :parent_id, :account_id
  end
end
