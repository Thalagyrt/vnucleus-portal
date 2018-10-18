class MoveNextDuePeriodStuffToProducts < ActiveRecord::Migration
  def change
    add_column :licenses_products, :next_due_period, :integer, default: 1
    add_column :licenses_products, :next_due_period_unit, :string, default: 'months'

    remove_column :licenses_licenses, :next_due_period
    remove_column :licenses_licenses, :next_due_period_unit
  end
end
