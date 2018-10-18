class CreateSolusInstallTimes < ActiveRecord::Migration
  def change
    create_table :solus_install_times do |t|
      t.integer :template_id
      t.integer :plan_id
      t.integer :install_time
      t.datetime :created_at
    end

    add_index :solus_install_times, :template_id
    add_index :solus_install_times, :plan_id
    add_index :solus_install_times, :created_at
  end
end
