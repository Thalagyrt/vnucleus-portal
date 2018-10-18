class CreateEmailAliases < ActiveRecord::Migration
  def change
    create_table :email_aliases do |t|
      t.integer :mailbox_id
      t.string :alias
      t.boolean :primary, default: false
    end

    add_index :email_aliases, :mailbox_id

    reversible do |dir|
      dir.up do
        Email::Mailbox.find_each do |mailbox|
          mailbox.aliases.create(primary: true, alias: mailbox.alias)
        end
      end
    end

    remove_column :email_mailboxes, :alias
  end
end
