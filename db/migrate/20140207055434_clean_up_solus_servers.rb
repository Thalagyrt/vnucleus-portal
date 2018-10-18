class CleanUpSolusServers < ActiveRecord::Migration
  def change
    remove_column :solus_servers, :solus_username
    remove_column :solus_servers, :solus_password
  end
end
