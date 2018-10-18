class AddStatusToChecksAndResults < ActiveRecord::Migration
  def change
    add_column :monitoring_checks, :status_code, :integer
    add_column :monitoring_results, :status_code, :integer

    execute 'UPDATE monitoring_checks SET status_code=0 WHERE successful=true'
    execute 'UPDATE monitoring_checks SET status_code=2 WHERE successful=false'
    execute 'UPDATE monitoring_results SET status_code=0 WHERE successful=true'
    execute 'UPDATE monitoring_results SET status_code=2 WHERE successful=false'

    change_column :monitoring_checks, :status_code, :integer, null: false
    change_column :monitoring_results, :status_code, :integer, null: false

    remove_column :monitoring_checks, :successful
    remove_column :monitoring_results, :successful
    remove_column :monitoring_checks, :priority
  end
end
