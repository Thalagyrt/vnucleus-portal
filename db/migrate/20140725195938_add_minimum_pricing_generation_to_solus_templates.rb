class AddMinimumPricingGenerationToSolusTemplates < ActiveRecord::Migration
  def change
    add_column :solus_templates, :minimum_pricing_generation, :integer, default: 0
  end
end
