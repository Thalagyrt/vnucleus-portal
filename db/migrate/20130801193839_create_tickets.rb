class CreateTickets < ActiveRecord::Migration
  def change
    create_table :tickets do |t|
      t.integer :account_id
      t.string :subject
      t.string :state
      t.string :priority
    end

    add_index :tickets, :account_id
    add_index :tickets, :state
    add_index :tickets, :priority
  end
end
