class AddPricingGenerationToSolusPlans < ActiveRecord::Migration
  def change
    add_column :solus_plans, :pricing_generation, :integer, default: 0
  end
end
