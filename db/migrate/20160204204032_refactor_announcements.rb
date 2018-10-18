class RefactorAnnouncements < ActiveRecord::Migration
  def change
    rename_table :communications_security_bulletins, :communications_announcements
    add_column :communications_announcements, :announcement_type, :integer

    execute 'UPDATE communications_announcements SET announcement_type=1'

    execute "INSERT INTO communications_announcements(subject, body, created_at, sent_at, sent_by_id, announcement_type) (SELECT subject, body, created_at, sent_at, sent_by_id, 2 FROM communications_product_announcements)"
  end
end
