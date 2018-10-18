class CreateAccountEvents < ActiveRecord::Migration
  def change
    create_table :account_events do |t|
      t.integer :account_id
      t.integer :user_id
      t.integer :entity_id
      t.string :entity_type
      t.string :message
      t.datetime :created_at
    end

    add_index :account_events, :account_id
    add_index :account_events, :user_id
    add_index :account_events, :entity_id
    add_index :account_events, :entity_type
    add_index :account_events, :created_at
  end
end
