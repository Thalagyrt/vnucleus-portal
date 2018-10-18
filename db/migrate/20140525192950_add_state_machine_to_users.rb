class AddStateMachineToUsers < ActiveRecord::Migration
  def change
    add_column :users_users, :state, :string
    add_index :users_users, :state
    execute "UPDATE users_users SET state='active'"
  end
end
