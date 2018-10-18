class AddLongIdToKnownIpAddresses < ActiveRecord::Migration
  def change
    add_column :users_known_ip_addresses, :long_id, :string
    add_index :users_known_ip_addresses, :long_id, unique: true

    reversible do |dir|
      dir.up do
        Users::EnhancedSecurityToken.find_each do |account|
          account.update_attribute :long_id, StringGenerator.long_id
        end
      end
    end
  end
end
