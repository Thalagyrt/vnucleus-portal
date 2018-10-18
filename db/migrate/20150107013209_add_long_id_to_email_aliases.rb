class AddLongIdToEmailAliases < ActiveRecord::Migration
  def change
    add_column :email_aliases, :long_id, :string
    add_index :email_aliases, :long_id, unique: true

    Email::Alias.find_each do |_alias|
      _alias.update long_id: StringGenerator.long_id
    end
  end
end
