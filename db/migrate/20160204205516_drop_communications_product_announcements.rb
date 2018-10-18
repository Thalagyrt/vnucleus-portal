class DropCommunicationsProductAnnouncements < ActiveRecord::Migration
  def change
    drop_table :communications_product_announcements
  end
end
