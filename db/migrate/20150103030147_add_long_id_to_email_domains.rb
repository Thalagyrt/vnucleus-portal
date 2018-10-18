class AddLongIdToEmailDomains < ActiveRecord::Migration
  def change
    add_column :email_domains, :long_id, :string
    add_index :email_domains, :long_id, unique: true

    reversible do |dir|
      dir.up do
        Email::Domain.find_each do |domain|
          domain.update_attribute :long_id, StringGenerator.long_id
        end
      end
    end
  end
end
