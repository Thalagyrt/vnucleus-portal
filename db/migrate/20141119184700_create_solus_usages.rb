class CreateSolusUsages < ActiveRecord::Migration
  def change
    create_table :solus_usages do |t|
      t.integer :node_id
      t.integer :template_id
      t.integer :count
      t.datetime :created_at
    end

    add_index :solus_usages, :node_id
    add_index :solus_usages, :template_id
    add_index :solus_usages, :created_at
  end
end
