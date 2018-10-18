class ChangeAhoyIdsToBigint < ActiveRecord::Migration
  def change
    change_column :visits, :id, :bigint
    change_column :ahoy_events, :id, :bigint
  end
end
