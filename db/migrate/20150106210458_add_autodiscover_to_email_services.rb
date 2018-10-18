class AddAutodiscoverToEmailServices < ActiveRecord::Migration
  def change
    add_column :email_services, :autodiscover_host, :string
    add_column :email_services, :autodiscover_port, :integer
  end
end
