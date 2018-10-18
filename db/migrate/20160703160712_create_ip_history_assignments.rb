class CreateIpHistoryAssignments < ActiveRecord::Migration
  def change
    create_table :ip_history_assignments do |t|
      t.integer :server_id
      t.string :server_type
      t.string :ip_address
      t.datetime :created_at
      t.datetime :last_seen_at
    end

    add_index :ip_history_assignments, [:server_id, :server_type]
    add_index :ip_history_assignments, :ip_address
    add_index :ip_history_assignments, :created_at
    add_index :ip_history_assignments, :last_seen_at
  end
end
