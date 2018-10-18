class CreatePlans < ActiveRecord::Migration
  def change
    create_table :plans do |t|
      t.string :name
      t.string :plan_part
      t.integer :ram
      t.integer :disk
      t.integer :vcpus
      t.integer :transfer
    end
  end
end
