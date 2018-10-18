class CreateNodes < ActiveRecord::Migration
  def change
    create_table :nodes do |t|
      t.string :name
      t.string :hostname
      t.string :ip_address
      t.integer :available_ram
      t.integer :available_disk
      t.integer :cluster_id
    end

    add_index :nodes, :cluster_id
  end
end
