class CreateMonitoring < ActiveRecord::Migration
  def change
    add_column :solus_servers, :pause_monitoring_until, :datetime
    add_index :solus_servers, :pause_monitoring_until


    create_table :monitoring_checks do |t|
      t.integer :server_id, null: false
      t.string :server_type, null: false

      # 1: icmp
      # 2: http
      # 3: ssl expiration
      # 4: tcp
      t.integer :test_type, null: false
      t.string :target_uri

      t.datetime :next_run_at, null: false
      t.datetime :last_run_at

      # to be set to true on first successful check. no notifications unless true
      # to be set to false on any modifications
      t.boolean :verified, default: false, null: false

      # 1: high
      # 2: low
      t.integer :priority, default: 1, null: false
      t.integer :failure_count, default: 0, null: false
      t.integer :notify_after_failures, default: 4, null: false

      # dispatch to staff via pagerduty
      t.boolean :notify_staff, default: false, null: false

      # dispatch to account members via email
      t.boolean :notify_account, default: true, null: false
    end
    add_index :monitoring_checks, :server_id
    add_index :monitoring_checks, :next_run_at


    create_table :monitoring_results do |t|
      t.integer :check_id, null: false
      t.integer :response_time, null: false
      t.boolean :successful, null: false
      t.string :status
      t.datetime :created_at, null: false
    end
    add_index :monitoring_results, :created_at
    add_index :monitoring_results, :check_id
    add_index :monitoring_results, :successful


    create_table :monitoring_notification_targets do |t|
      t.integer :account_id, null: false

      # values are 1 and 2, 255 will give us up to 8 priorities
      t.integer :priority_mask, default: 255, null: false

      # 1: email
      # 2: customer pagerduty
      t.integer :target_type, null: false

      # the email address or service key
      t.string :target_value, null: false

      # we'll send a test notification with a verification code, both to pagerduty and email targets
      t.boolean :target_verified, default: false, null: false
      t.string :verification_code, null: false
    end
    add_index :monitoring_notification_targets, :account_id


    create_table :monitoring_check_notification_targets do |t|
      t.integer :check_id, null: false
      t.integer :notification_target_id, null: false
    end
    add_index :monitoring_check_notification_targets, :check_id, name: 'monitoring_check_nt_check_id'
    add_index :monitoring_check_notification_targets, :notification_target_id, name: 'monitoring_check_nt_target_id'


    create_table :monitoring_notifications do |t|
      t.integer :check_id, null: false
      t.integer :notification_target_id

      t.datetime :created_at, null: false
      t.datetime :sent_at
      t.datetime :resolved_at

      # we clone this data in so we can resolve it even if the notification target is deleted or modified
      t.string :target_type, null: false
      t.string :target_value, null: false
      t.string :target_key
    end
    add_index :monitoring_notifications, :check_id
    add_index :monitoring_notifications, :notification_target_id
    add_index :monitoring_notifications, :created_at
    add_index :monitoring_notifications, :sent_at
    add_index :monitoring_notifications, :resolved_at
  end
end
