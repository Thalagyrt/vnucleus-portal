class AddLongIdToEmailMailboxes < ActiveRecord::Migration
  def change
    add_column :email_mailboxes, :long_id, :string
    add_index :email_mailboxes, :long_id, unique: true

    reversible do |dir|
      dir.up do
        Email::Mailbox.find_each do |mailbox|
          mailbox.update_attribute :long_id, StringGenerator.long_id
        end
      end
    end
  end
end
