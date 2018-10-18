class AddReceiveSecurityBulletinsToUsers < ActiveRecord::Migration
  def change
    add_column :users_users, :receive_security_bulletins, :boolean, default: true
    add_index :users_users, :receive_security_bulletins
  end
end
