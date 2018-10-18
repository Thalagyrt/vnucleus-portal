class CreateEmailMailboxes < ActiveRecord::Migration
  def change
    create_table :email_mailboxes do |t|
      t.integer :domain_id
      t.string :alias
      t.string :state
      t.integer :amount
      t.date :next_due
      t.datetime :created_at
      t.datetime :updated_at
    end

    add_index :email_mailboxes, :domain_id
    add_index :email_mailboxes, :alias
    add_index :email_mailboxes, [:domain_id, :alias], unique: true
    add_index :email_mailboxes, :next_due
    add_index :email_mailboxes, :created_at
    add_index :email_mailboxes, :updated_at
  end
end
