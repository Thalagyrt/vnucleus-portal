class RemovePricingGeneration < ActiveRecord::Migration
  def change
    remove_column :solus_servers, :pricing_generation
    remove_column :solus_plans, :pricing_generation
    remove_column :solus_templates, :minimum_pricing_generation
  end
end
