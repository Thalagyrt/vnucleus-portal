class AddRootUsernameToDedicatedServers < ActiveRecord::Migration
  def change
    add_column :dedicated_servers, :root_username, :string
  end
end
