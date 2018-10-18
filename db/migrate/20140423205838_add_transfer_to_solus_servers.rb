class AddTransferToSolusServers < ActiveRecord::Migration
  def change
    add_column :solus_servers, :transfer, :bigint, default: 1
  end
end

