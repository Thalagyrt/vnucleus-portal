class CreateServers < ActiveRecord::Migration
  def change
    create_table :servers do |t|
      t.string :hostname
      t.integer :vserver_id
      t.integer :account_id
      t.integer :plan_id
      t.integer :node_id
      t.integer :template_id
      t.string :solus_username
      t.string :solus_password
      t.string :root_password
    end

    add_index :servers, :vserver_id, unique: true
    add_index :servers, :solus_username, unique: true
    add_index :servers, :account_id
    add_index :servers, :plan_id
    add_index :servers, :node_id
    add_index :servers, :template_id
  end
end
