class CreateServiceNotices < ActiveRecord::Migration
  def change
    create_table :service_notices do |t|
      t.string :message
    end
  end
end
