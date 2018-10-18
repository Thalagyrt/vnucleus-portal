class DropNextDueStuffFromProducts < ActiveRecord::Migration
  def change
    remove_column :licenses_products, :next_due_period
    remove_column :licenses_products, :next_due_period_unit
  end
end
