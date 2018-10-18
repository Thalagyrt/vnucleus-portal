class CreateDedicatedServers < ActiveRecord::Migration
  def change
    create_table :dedicated_servers do |t|
      t.integer :account_id
      t.string :hostname
      t.string :ip_address
      t.string :root_password
      t.integer :amount
      t.string :state
      t.date :next_due
      t.string :long_id
      t.date :patch_at
      t.integer :patch_period
      t.string :patch_period_unit
      t.boolean :patch_out_of_band
      t.integer :backup_user_id
      t.string :ptr_hostname
      t.date :terminate_on
      t.date :suspend_on
      t.string :termination_reason
      t.string :suspension_reason
      t.datetime :created_at
      t.datetime :updated_at
    end

    add_index :dedicated_servers, :account_id
    add_index :dedicated_servers, :state
    add_index :dedicated_servers, :next_due
    add_index :dedicated_servers, :long_id, unique: true
    add_index :dedicated_servers, :patch_at
    add_index :dedicated_servers, :patch_out_of_band
    add_index :dedicated_servers, :terminate_on
    add_index :dedicated_servers, :suspend_on
    add_index :dedicated_servers, :created_at
    add_index :dedicated_servers, :updated_at
  end
end
