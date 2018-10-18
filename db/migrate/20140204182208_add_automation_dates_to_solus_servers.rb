class AddAutomationDatesToSolusServers < ActiveRecord::Migration
  def change
    add_column :solus_servers, :suspend_on, :date
    add_column :solus_servers, :terminate_on, :date

    add_index :solus_servers, :suspend_on
    add_index :solus_servers, :terminate_on
  end
end
