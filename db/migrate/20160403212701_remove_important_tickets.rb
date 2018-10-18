class RemoveImportantTickets < ActiveRecord::Migration
  def change
    execute 'UPDATE tickets_tickets SET priority=1 WHERE priority=2'
    execute 'UPDATE tickets_updates SET priority=1 WHERE priority=2'
  end
end
