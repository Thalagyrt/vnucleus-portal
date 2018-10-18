class UpdateSolusServerStatesFromSplit < ActiveRecord::Migration
  def up
    execute "UPDATE solus_servers SET state='automation_terminated' WHERE state='terminated'"
    execute "UPDATE solus_servers SET state='automation_suspended' WHERE state='suspended'"
  end

  def down
    execute "UPDATE solus_servers SET state='terminated' WHERE state='automation_terminated'"
    execute "UPDATE solus_servers SET state='suspended' WHERE state='automation_suspended'"
  end
end
