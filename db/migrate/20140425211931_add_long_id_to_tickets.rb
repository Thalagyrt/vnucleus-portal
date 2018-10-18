class AddLongIdToTickets < ActiveRecord::Migration
  def change
    add_column :tickets_tickets, :long_id, :string
    add_index :tickets_tickets, :long_id, unique: true

    reversible do |dir|
      dir.up do
        Tickets::Ticket.find_each do |ticket|
          ticket.update_attribute :long_id, StringGenerator.long_id
        end
      end
    end
  end
end
