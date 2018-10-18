class AddPricingGenerationToSolusServers < ActiveRecord::Migration
  def change
    add_column :solus_servers, :pricing_generation, :integer, default: 0
  end
end
