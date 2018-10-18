class AddPerformanceDataToMonitoringResults < ActiveRecord::Migration
  def change
    add_column :monitoring_results, :performance_data, :text
  end
end
