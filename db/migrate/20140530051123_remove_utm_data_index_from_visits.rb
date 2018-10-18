class RemoveUtmDataIndexFromVisits < ActiveRecord::Migration
  def change
    remove_index :visits, :utm_data
  end
end
