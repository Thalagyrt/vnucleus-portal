class CreateClusters < ActiveRecord::Migration
  def change
    create_table :clusters do |t|
      t.string :name
      t.string :hostname
      t.string :ip_address
      t.string :api_id
      t.string :api_secret
      t.integer :available_ipv4
      t.integer :available_ipv6
    end
  end
end
