class CreateUsersEmailLogEntries < ActiveRecord::Migration
  def change
    create_table :users_email_log_entries do |t|
      t.integer :user_id, null: false
      t.string :to, null: false
      t.datetime :created_at, null: false
      t.string :subject, null: false
      t.text :body, null: false
    end

    add_index :users_email_log_entries, :to
    add_index :users_email_log_entries, :user_id
    add_index :users_email_log_entries, :created_at
  end
end
