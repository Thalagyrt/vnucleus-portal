class AddSecureBodyToTicketUpdates < ActiveRecord::Migration
  def change
    add_column :tickets_updates, :secure_body, :text
  end
end
