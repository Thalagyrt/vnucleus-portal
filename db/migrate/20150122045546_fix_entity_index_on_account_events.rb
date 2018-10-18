class FixEntityIndexOnAccountEvents < ActiveRecord::Migration
  def change
    remove_index :accounts_events, name: 'index_account_events_on_entity_id'
    remove_index :accounts_events, name: 'index_account_events_on_entity_type'
    add_index :accounts_events, [:entity_id, :entity_type]
  end
end
