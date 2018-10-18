class RenameTicketStateToStatus < ActiveRecord::Migration
  def change
    rename_column :tickets, :state, :status
  end
end
