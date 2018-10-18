class DropPerformanceData < ActiveRecord::Migration
  def change
    remove_column :monitoring_results, :performance_data
  end
end
