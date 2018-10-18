class CreateEmailDomains < ActiveRecord::Migration
  def change
    create_table :email_domains do |t|
      t.integer :account_id
      t.string :domain_name
      t.string :state
      t.datetime :created_at
      t.datetime :updated_at
    end

    add_index :email_domains, :account_id
    add_index :email_domains, :state
    add_index :email_domains, :created_at
    add_index :email_domains, :updated_at
  end
end
