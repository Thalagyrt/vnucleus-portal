class AddIncidentIdToTickets < ActiveRecord::Migration
  def change
    add_column :tickets_tickets, :incident_key, :string
  end
end
