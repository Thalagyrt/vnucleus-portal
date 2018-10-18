class CreateUsersResetTokens < ActiveRecord::Migration
  def change
    create_table :users_tokens do |t|
      t.integer :user_id
      t.string :token
      t.string :kind
      t.datetime :expires_at
    end

    add_index :users_tokens, :user_id
    add_index :users_tokens, [:token, :kind], unique: true
    add_index :users_tokens, :expires_at
  end
end
