class AddConsoleRequestedByToSolusServers < ActiveRecord::Migration
  def change
    add_column :solus_servers, :console_requested_by_id, :integer
  end
end
