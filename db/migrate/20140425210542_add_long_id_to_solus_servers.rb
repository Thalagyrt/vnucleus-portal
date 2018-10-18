class AddLongIdToSolusServers < ActiveRecord::Migration
  def change
    add_column :solus_servers, :long_id, :string
    add_index :solus_servers, :long_id, unique: true

    reversible do |dir|
      dir.up do
        Solus::Server.find_each do |server|
          server.update_attribute :long_id, StringGenerator.long_id
        end
      end
    end
  end
end
