class AddPagerdutyApiKeyToTickets < ActiveRecord::Migration
  def change
    add_column :tickets_tickets, :pagerduty_api_key, :string
  end
end
