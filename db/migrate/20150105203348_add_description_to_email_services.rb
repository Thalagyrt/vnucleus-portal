class AddDescriptionToEmailServices < ActiveRecord::Migration
  def change
    add_column :email_services, :description, :text
  end
end
