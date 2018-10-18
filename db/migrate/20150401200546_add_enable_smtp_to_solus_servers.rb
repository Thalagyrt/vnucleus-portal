class AddEnableSmtpToSolusServers < ActiveRecord::Migration
  def change
    add_column :solus_servers, :enable_smtp, :boolean, default: false
  end
end
