class CreatePlanTemplates < ActiveRecord::Migration
  def change
    create_table :solus_plan_templates do |t|
      t.integer :plan_id
      t.integer :template_id
    end

    add_index :solus_plan_templates, [:plan_id, :template_id], unique: true
  end
end
