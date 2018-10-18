class CreateCommunicationsSecurityBulletins < ActiveRecord::Migration
  def change
    create_table :communications_security_bulletins do |t|
      t.string :subject
      t.text :body
      t.datetime :created_at
      t.datetime :sent_at
      t.integer :sent_by_id
    end

    add_index :communications_security_bulletins, :created_at
    add_index :communications_security_bulletins, :sent_at
    add_index :communications_security_bulletins, :sent_by_id
  end
end
