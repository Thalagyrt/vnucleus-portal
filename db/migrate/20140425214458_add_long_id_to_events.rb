class AddLongIdToEvents < ActiveRecord::Migration
  def change
    add_column :accounts_events, :long_id, :string
    add_index :accounts_events, :long_id, unique: true

    reversible do |dir|
      dir.up do
        Accounts::Event.find_each do |event|
          event.update_attribute :long_id, StringGenerator.long_id
        end
      end
    end
  end
end
