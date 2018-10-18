class AddIndexOnCountToSolusUsages < ActiveRecord::Migration
  def change
    add_index :solus_usages, :count
  end
end
