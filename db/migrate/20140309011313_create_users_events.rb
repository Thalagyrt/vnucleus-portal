class CreateUsersEvents < ActiveRecord::Migration
  def change
    create_table :users_events do |t|
      t.integer :user_id
      t.string :message
      t.string :ip_address
      t.string :category
      t.datetime :created_at
    end

    add_index :users_events, :user_id
    add_index :users_events, :created_at
    add_index :users_events, :category
  end
end
