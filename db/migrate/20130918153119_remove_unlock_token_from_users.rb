class RemoveUnlockTokenFromUsers < ActiveRecord::Migration
  def up
    remove_column :users, :unlock_token
  end

  def down
    add_column :users, :unlock_token, :string
  end
end
