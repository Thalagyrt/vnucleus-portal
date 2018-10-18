class UpdateTerminationReasonAndSuspensionReasonToUseI18n < ActiveRecord::Migration
  def up
    execute "UPDATE solus_servers SET termination_reason='payment_not_received' WHERE termination_reason ILIKE 'Non-Payment'"
    execute "UPDATE solus_servers SET suspension_reason='payment_not_received' WHERE suspension_reason ILIKE 'Non-Payment'"
  end
end
