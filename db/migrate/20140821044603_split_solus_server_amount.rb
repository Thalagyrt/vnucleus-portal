class SplitSolusServerAmount < ActiveRecord::Migration
  def change
    add_column :solus_servers, :plan_amount, :integer, default: 0
    add_column :solus_servers, :template_amount, :integer, default: 0
    execute 'UPDATE solus_servers SET plan_amount=amount'
  end
end
