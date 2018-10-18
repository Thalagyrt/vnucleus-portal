class AddAmountToSolusTemplates < ActiveRecord::Migration
  def change
    add_column :solus_templates, :amount, :integer, default: 0
  end
end
