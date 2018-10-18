class CreateUsersNotifications < ActiveRecord::Migration
  def change
    create_table :users_notifications do |t|
      t.integer :user_id
      t.integer :actor_id
      t.integer :target_id
      t.string :target_type
      t.string :message
      t.string :link_policy
      t.datetime :created_at
      t.boolean :read, default: false
    end

    add_index :users_notifications, :user_id
    add_index :users_notifications, :actor_id
    add_index :users_notifications, [:target_id, :target_type]
    add_index :users_notifications, :created_at
    add_index :users_notifications, :read
  end
end
