class AddSuspensionReasonToSolusServers < ActiveRecord::Migration
  def change
    add_column :solus_servers, :suspension_reason, :string
  end
end
