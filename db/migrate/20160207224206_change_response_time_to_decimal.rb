class ChangeResponseTimeToDecimal < ActiveRecord::Migration
  def change
    change_column :monitoring_results, :response_time, :decimal, null: false
  end
end
