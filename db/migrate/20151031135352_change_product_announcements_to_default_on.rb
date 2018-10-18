class ChangeProductAnnouncementsToDefaultOn < ActiveRecord::Migration
  def change
    change_column :users_users, :receive_product_announcements, :boolean, default: true
  end
end
