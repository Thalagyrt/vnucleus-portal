class CreateCommunicationsProductAnnouncements < ActiveRecord::Migration
  def change
    create_table :communications_product_announcements do |t|
      t.string   :subject
      t.text     :body
      t.datetime :created_at
      t.datetime :sent_at
      t.integer  :sent_by_id
    end

    add_index :communications_product_announcements, :created_at
    add_index :communications_product_announcements, :sent_at
    add_index :communications_product_announcements, :sent_by_id
  end
end
