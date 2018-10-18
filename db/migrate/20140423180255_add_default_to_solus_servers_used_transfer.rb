class AddDefaultToSolusServersUsedTransfer < ActiveRecord::Migration
  def change
    change_column_default :solus_servers, :used_transfer, 0
  end
end
