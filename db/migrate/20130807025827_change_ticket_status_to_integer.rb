class ChangeTicketStatusToInteger < ActiveRecord::Migration
  def up
    execute "update tickets set status='1' where status='open'"
    execute "ALTER TABLE tickets ALTER status TYPE integer USING status::int;"
  end

  def down
    change_column :tickets, :status, :string
    execute "update tickets set status='open' where status='1'"
  end
end
