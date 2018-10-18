class RemoveUserTypeFromAhoy < ActiveRecord::Migration
  def change
    remove_column :ahoy_visits, :user_type
    remove_column :ahoy_events, :user_type
  end
end
