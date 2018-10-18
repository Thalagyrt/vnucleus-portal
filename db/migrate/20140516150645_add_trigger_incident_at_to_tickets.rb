class AddTriggerIncidentAtToTickets < ActiveRecord::Migration
  def change
    add_column :tickets_tickets, :trigger_incident_at, :datetime
    add_index :tickets_tickets, :trigger_incident_at
  end
end
