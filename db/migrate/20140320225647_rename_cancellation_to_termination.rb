class RenameCancellationToTermination < ActiveRecord::Migration
  def up
    rename_column :solus_servers, :cancellation_reason, :termination_reason
    execute "UPDATE solus_servers SET state='user_terminated' WHERE state='cancelled'"
    execute "UPDATE solus_servers SET state='pending_user_termination' WHERE state='pending_cancellation'"
  end

  def down
    rename_column :solus_servers, :termination_reason, :cancellation_reason
    execute "UPDATE solus_servers SET state='cancelled' WHERE state='user_terminated'"
    execute "UPDATE solus_servers SET state='pending_cancellation' WHERE state='pending_user_termination'"
  end
end
