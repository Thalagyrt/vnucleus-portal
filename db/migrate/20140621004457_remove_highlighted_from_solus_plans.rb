class RemoveHighlightedFromSolusPlans < ActiveRecord::Migration
  def change
    execute 'UPDATE solus_plans SET feature_status=2 WHERE feature_status=3'
  end
end
