class AddLastSeenAtToKnownIpAddresses < ActiveRecord::Migration
  def change
    add_column :users_known_ip_addresses, :last_seen_at, :datetime

    execute "UPDATE users_known_ip_addresses SET last_seen_at=expires_at - interval '3 months'"
  end
end
