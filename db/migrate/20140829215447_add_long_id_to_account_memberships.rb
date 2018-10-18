class AddLongIdToAccountMemberships < ActiveRecord::Migration
  def change
    add_column :accounts_memberships, :long_id, :string
    add_index :accounts_memberships, :long_id, unique: true

    reversible do |dir|
      dir.up do
        Accounts::Membership.find_each do |membership|
          membership.update_attribute :long_id, StringGenerator.long_id
        end
      end
    end
  end
end
