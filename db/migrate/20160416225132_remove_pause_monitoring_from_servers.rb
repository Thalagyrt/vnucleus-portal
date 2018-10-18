class RemovePauseMonitoringFromServers < ActiveRecord::Migration
  def change
    remove_column :solus_servers, :pause_monitoring_until
  end
end
