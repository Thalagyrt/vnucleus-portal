class AddCancellationReasonToSolusServers < ActiveRecord::Migration
  def change
    add_column :solus_servers, :cancellation_reason, :string
  end
end
