class CreateEmailServices < ActiveRecord::Migration
  def change
    create_table :email_services do |t|
      t.string :name
      t.string :webmail_uri
      t.string :mx_records, array: true, default: "{}"
    end
  end
end
