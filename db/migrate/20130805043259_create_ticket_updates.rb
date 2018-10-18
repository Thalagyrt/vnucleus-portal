class CreateTicketUpdates < ActiveRecord::Migration
  def change
    create_table :ticket_updates do |t|
      t.integer :ticket_id
      t.integer :user_id
      t.text :body

      t.datetime :created_at
    end

    add_index :ticket_updates, :ticket_id
    add_index :ticket_updates, :user_id
  end
end
