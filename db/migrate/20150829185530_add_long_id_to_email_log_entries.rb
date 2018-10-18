class AddLongIdToEmailLogEntries < ActiveRecord::Migration
  def change
    add_column :users_email_log_entries, :long_id, :string
    add_index :users_email_log_entries, :long_id

    Users::EmailLogEntry.find_each do |entry|
      loop do
        entry.long_id = StringGenerator.long_id
        break unless Users::EmailLogEntry.exists?(long_id: entry.long_id)
      end
      entry.save!
    end
  end
end
