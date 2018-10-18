class ChangeDelayedJobIdsToBigint < ActiveRecord::Migration
  def change
    change_column :delayed_jobs, :id, :bigint
  end
end
