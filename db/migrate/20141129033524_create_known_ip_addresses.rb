class CreateKnownIpAddresses < ActiveRecord::Migration
  def change
    create_table :users_known_ip_addresses do |t|
      t.integer :user_id
      t.string :ip_address
      t.datetime :created_at
      t.datetime :expires_at
    end

    add_index :users_known_ip_addresses, :user_id
    add_index :users_known_ip_addresses, :ip_address
    add_index :users_known_ip_addresses, [:user_id, :ip_address], unique: true
    add_index :users_known_ip_addresses, :created_at
    add_index :users_known_ip_addresses, :expires_at
  end
end
