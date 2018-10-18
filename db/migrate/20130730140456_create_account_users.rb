class CreateAccountUsers < ActiveRecord::Migration
  def change
    create_table :account_users do |t|
      t.integer :user_id
      t.integer :account_id
      t.integer :roles
    end

    add_index :account_users, :user_id
    add_index :account_users, :account_id
  end
end
