class AddPeriodToLicenses < ActiveRecord::Migration
  def change
    add_column :accounts_licenses, :next_due_period, :integer, default: 1
    add_column :accounts_licenses, :next_due_period_unit, :string, default: 'month'
  end
end
