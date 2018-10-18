class CreateEmailUsages < ActiveRecord::Migration
  def change
    create_table :email_usages do |t|
      t.datetime :created_at
      t.integer :mailbox_id
      t.integer :account_id
    end

    add_index :email_usages, :created_at
    add_index :email_usages, :mailbox_id
    add_index :email_usages, :account_id
  end
end
