class AddAmountToSolusServers < ActiveRecord::Migration
  def change
    add_column :solus_servers, :amount, :integer
  end
end
