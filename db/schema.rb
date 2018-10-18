# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160827212644) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts_accounts", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at"
    t.string   "stripe_id"
    t.date     "stripe_expiration_date"
    t.boolean  "stripe_valid"
    t.string   "state"
    t.text     "maxmind_response"
    t.string   "address_line1"
    t.string   "address_line2"
    t.string   "address_city"
    t.string   "address_state"
    t.string   "address_zip"
    t.string   "address_country"
    t.string   "long_id"
    t.string   "welcome_state"
    t.integer  "visit_id"
    t.date     "next_due"
    t.integer  "referrer_id"
    t.date     "pay_referrer_at"
    t.boolean  "affiliate_enabled",      default: true
    t.integer  "balance_cache",          default: 0
    t.integer  "server_count_cache",     default: 0
    t.integer  "monthly_rate_cache",     default: 0
    t.datetime "credit_card_updated_at"
    t.date     "close_on"
    t.string   "entity_name"
    t.string   "nickname"
  end

  add_index "accounts_accounts", ["balance_cache"], name: "index_accounts_accounts_on_balance_cache", using: :btree
  add_index "accounts_accounts", ["close_on"], name: "index_accounts_accounts_on_close_on", using: :btree
  add_index "accounts_accounts", ["credit_card_updated_at"], name: "index_accounts_accounts_on_credit_card_updated_at", using: :btree
  add_index "accounts_accounts", ["long_id"], name: "index_accounts_accounts_on_long_id", unique: true, using: :btree
  add_index "accounts_accounts", ["monthly_rate_cache"], name: "index_accounts_accounts_on_monthly_rate_cache", using: :btree
  add_index "accounts_accounts", ["pay_referrer_at"], name: "index_accounts_accounts_on_pay_referrer_at", using: :btree
  add_index "accounts_accounts", ["referrer_id"], name: "index_accounts_accounts_on_referrer_id", using: :btree
  add_index "accounts_accounts", ["server_count_cache"], name: "index_accounts_accounts_on_server_count_cache", using: :btree
  add_index "accounts_accounts", ["stripe_expiration_date"], name: "index_accounts_on_stripe_expiration_date", using: :btree
  add_index "accounts_accounts", ["visit_id"], name: "index_accounts_accounts_on_visit_id", using: :btree

  create_table "accounts_backup_users", force: :cascade do |t|
    t.integer "account_id"
    t.string  "username"
    t.string  "password"
    t.string  "hostname"
  end

  add_index "accounts_backup_users", ["account_id"], name: "index_accounts_backup_users_on_account_id", using: :btree

  create_table "accounts_events", force: :cascade do |t|
    t.integer  "account_id"
    t.integer  "user_id"
    t.integer  "entity_id"
    t.string   "entity_type"
    t.string   "message"
    t.datetime "created_at"
    t.string   "ip_address"
    t.string   "category"
    t.string   "long_id"
  end

  add_index "accounts_events", ["account_id"], name: "index_account_events_on_account_id", using: :btree
  add_index "accounts_events", ["category"], name: "index_account_events_on_category", using: :btree
  add_index "accounts_events", ["created_at"], name: "index_account_events_on_created_at", using: :btree
  add_index "accounts_events", ["entity_id", "entity_type"], name: "index_accounts_events_on_entity_id_and_entity_type", using: :btree
  add_index "accounts_events", ["long_id"], name: "index_accounts_events_on_long_id", unique: true, using: :btree
  add_index "accounts_events", ["user_id"], name: "index_account_events_on_user_id", using: :btree

  create_table "accounts_invites", force: :cascade do |t|
    t.integer  "account_id"
    t.string   "email"
    t.integer  "roles_mask"
    t.datetime "created_at"
    t.string   "state"
  end

  add_index "accounts_invites", ["account_id"], name: "index_accounts_invites_on_account_id", using: :btree
  add_index "accounts_invites", ["created_at"], name: "index_accounts_invites_on_created_at", using: :btree
  add_index "accounts_invites", ["state"], name: "index_accounts_invites_on_state", using: :btree

  create_table "accounts_memberships", force: :cascade do |t|
    t.integer "user_id"
    t.integer "account_id"
    t.integer "roles_mask"
    t.string  "long_id"
  end

  add_index "accounts_memberships", ["account_id"], name: "index_account_users_on_account_id", using: :btree
  add_index "accounts_memberships", ["long_id"], name: "index_accounts_memberships_on_long_id", unique: true, using: :btree
  add_index "accounts_memberships", ["user_id"], name: "index_account_users_on_user_id", using: :btree

  create_table "accounts_notes", force: :cascade do |t|
    t.text    "body"
    t.integer "user_id"
    t.integer "account_id"
    t.integer "created_at"
  end

  add_index "accounts_notes", ["account_id"], name: "index_accounts_notes_on_account_id", using: :btree
  add_index "accounts_notes", ["created_at"], name: "index_accounts_notes_on_created_at", using: :btree
  add_index "accounts_notes", ["user_id"], name: "index_accounts_notes_on_user_id", using: :btree

  create_table "accounts_transactions", force: :cascade do |t|
    t.integer  "account_id"
    t.integer  "amount"
    t.integer  "fee"
    t.string   "reference"
    t.string   "description"
    t.datetime "created_at"
    t.string   "category"
  end

  add_index "accounts_transactions", ["account_id"], name: "index_account_transactions_on_account_id", using: :btree
  add_index "accounts_transactions", ["category"], name: "index_account_transactions_on_category", using: :btree

  create_table "ahoy_events", force: :cascade do |t|
    t.integer  "visit_id"
    t.integer  "user_id"
    t.string   "name"
    t.text     "properties"
    t.datetime "time"
  end

  add_index "ahoy_events", ["time"], name: "index_ahoy_events_on_time", using: :btree
  add_index "ahoy_events", ["visit_id"], name: "index_ahoy_events_on_visit_id", using: :btree

  create_table "ahoy_visits", force: :cascade do |t|
    t.string   "visit_token"
    t.string   "visitor_token"
    t.string   "ip"
    t.text     "user_agent"
    t.text     "referrer"
    t.text     "landing_page"
    t.integer  "user_id"
    t.string   "referring_domain"
    t.string   "search_keyword"
    t.string   "browser"
    t.string   "os"
    t.string   "device_type"
    t.string   "country"
    t.string   "region"
    t.string   "city"
    t.string   "utm_source"
    t.string   "utm_medium"
    t.string   "utm_term"
    t.string   "utm_content"
    t.string   "utm_campaign"
    t.datetime "created_at"
  end

  add_index "ahoy_visits", ["visit_token"], name: "index_ahoy_visits_on_visit_token", unique: true, using: :btree

  create_table "blog_posts", force: :cascade do |t|
    t.string   "title"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "status"
    t.integer  "user_id"
    t.datetime "published_at"
    t.text     "summary"
  end

  add_index "blog_posts", ["created_at"], name: "index_blog_posts_on_created_at", using: :btree
  add_index "blog_posts", ["published_at"], name: "index_blog_posts_on_published_at", using: :btree
  add_index "blog_posts", ["status"], name: "index_blog_posts_on_status", using: :btree
  add_index "blog_posts", ["updated_at"], name: "index_blog_posts_on_updated_at", using: :btree
  add_index "blog_posts", ["user_id"], name: "index_blog_posts_on_user_id", using: :btree

  create_table "communications_announcements", force: :cascade do |t|
    t.string   "subject"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "sent_at"
    t.integer  "sent_by_id"
    t.integer  "announcement_type"
  end

  add_index "communications_announcements", ["created_at"], name: "index_communications_announcements_on_created_at", using: :btree
  add_index "communications_announcements", ["sent_at"], name: "index_communications_announcements_on_sent_at", using: :btree
  add_index "communications_announcements", ["sent_by_id"], name: "index_communications_announcements_on_sent_by_id", using: :btree

  create_table "dedicated_servers", force: :cascade do |t|
    t.integer  "account_id"
    t.string   "hostname"
    t.string   "ip_address"
    t.string   "root_password"
    t.integer  "amount"
    t.string   "state"
    t.date     "next_due"
    t.string   "long_id"
    t.date     "patch_at"
    t.integer  "patch_period"
    t.string   "patch_period_unit"
    t.boolean  "patch_out_of_band"
    t.integer  "backup_user_id"
    t.string   "ptr_hostname"
    t.date     "terminate_on"
    t.date     "suspend_on"
    t.string   "termination_reason"
    t.string   "suspension_reason"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "managed",            default: false
    t.string   "root_username"
  end

  add_index "dedicated_servers", ["account_id"], name: "index_dedicated_servers_on_account_id", using: :btree
  add_index "dedicated_servers", ["created_at"], name: "index_dedicated_servers_on_created_at", using: :btree
  add_index "dedicated_servers", ["long_id"], name: "index_dedicated_servers_on_long_id", unique: true, using: :btree
  add_index "dedicated_servers", ["next_due"], name: "index_dedicated_servers_on_next_due", using: :btree
  add_index "dedicated_servers", ["patch_at"], name: "index_dedicated_servers_on_patch_at", using: :btree
  add_index "dedicated_servers", ["patch_out_of_band"], name: "index_dedicated_servers_on_patch_out_of_band", using: :btree
  add_index "dedicated_servers", ["state"], name: "index_dedicated_servers_on_state", using: :btree
  add_index "dedicated_servers", ["suspend_on"], name: "index_dedicated_servers_on_suspend_on", using: :btree
  add_index "dedicated_servers", ["terminate_on"], name: "index_dedicated_servers_on_terminate_on", using: :btree
  add_index "dedicated_servers", ["updated_at"], name: "index_dedicated_servers_on_updated_at", using: :btree

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "email_services", force: :cascade do |t|
    t.string  "name"
    t.string  "webmail_uri"
    t.string  "mx_records",        default: [], array: true
    t.text    "description"
    t.string  "autodiscover_host"
    t.integer "autodiscover_port"
    t.text    "spf_records"
  end

  create_table "ip_history_assignments", force: :cascade do |t|
    t.integer  "server_id"
    t.string   "server_type"
    t.string   "ip_address"
    t.datetime "created_at"
    t.datetime "last_seen_at"
  end

  add_index "ip_history_assignments", ["created_at"], name: "index_ip_history_assignments_on_created_at", using: :btree
  add_index "ip_history_assignments", ["ip_address"], name: "index_ip_history_assignments_on_ip_address", using: :btree
  add_index "ip_history_assignments", ["last_seen_at"], name: "index_ip_history_assignments_on_last_seen_at", using: :btree
  add_index "ip_history_assignments", ["server_id", "server_type"], name: "index_ip_history_assignments_on_server_id_and_server_type", using: :btree

  create_table "knowledge_base_articles", force: :cascade do |t|
    t.string   "title"
    t.text     "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "status"
    t.text     "summary"
  end

  add_index "knowledge_base_articles", ["status"], name: "index_knowledge_base_articles_on_status", using: :btree

  create_table "leads_leads", force: :cascade do |t|
    t.string   "email"
    t.text     "body"
    t.datetime "created_at"
    t.integer  "visit_id"
    t.string   "first_name"
    t.string   "last_name"
  end

  add_index "leads_leads", ["created_at"], name: "index_leads_leads_on_created_at", using: :btree

  create_table "licenses_licenses", force: :cascade do |t|
    t.integer "account_id"
    t.integer "count"
    t.date    "next_due"
    t.integer "product_id"
    t.boolean "free",         default: false
    t.string  "note"
    t.integer "max_count"
    t.string  "product_code"
    t.string  "description"
  end

  add_index "licenses_licenses", ["account_id"], name: "index_licenses_licenses_on_account_id", using: :btree
  add_index "licenses_licenses", ["next_due"], name: "index_licenses_licenses_on_next_due", using: :btree
  add_index "licenses_licenses", ["product_id"], name: "index_licenses_licenses_on_product_id", using: :btree

  create_table "licenses_products", force: :cascade do |t|
    t.string  "product_code"
    t.string  "description"
    t.integer "amount",       default: 0
  end

  create_table "licenses_usages", force: :cascade do |t|
    t.integer  "product_id"
    t.integer  "count"
    t.datetime "created_at"
    t.integer  "account_id"
  end

  add_index "licenses_usages", ["account_id"], name: "index_licenses_usages_on_account_id", using: :btree
  add_index "licenses_usages", ["created_at"], name: "index_licenses_usages_on_created_at", using: :btree
  add_index "licenses_usages", ["product_id"], name: "index_licenses_usages_on_product_id", using: :btree

  create_table "monitoring_check_notification_targets", force: :cascade do |t|
    t.integer "check_id",               null: false
    t.integer "notification_target_id", null: false
  end

  add_index "monitoring_check_notification_targets", ["check_id"], name: "monitoring_check_nt_check_id", using: :btree
  add_index "monitoring_check_notification_targets", ["notification_target_id"], name: "monitoring_check_nt_target_id", using: :btree

  create_table "monitoring_checks", force: :cascade do |t|
    t.integer  "server_id",                             null: false
    t.string   "server_type",                           null: false
    t.integer  "check_type",                            null: false
    t.string   "check_data"
    t.datetime "next_run_at",                           null: false
    t.datetime "last_run_at"
    t.boolean  "verified",              default: false, null: false
    t.integer  "failure_count",         default: 0,     null: false
    t.integer  "notify_after_failures", default: 4,     null: false
    t.boolean  "notify_staff",          default: false, null: false
    t.boolean  "notify_account",        default: true,  null: false
    t.boolean  "enabled",               default: true
    t.string   "server_hostname"
    t.string   "server_long_id"
    t.string   "test_to_s"
    t.string   "long_id"
    t.integer  "account_id"
    t.integer  "status_code",           default: 3,     null: false
    t.boolean  "deleted",               default: false, null: false
    t.datetime "muzzle_until"
  end

  add_index "monitoring_checks", ["account_id"], name: "index_monitoring_checks_on_account_id", using: :btree
  add_index "monitoring_checks", ["deleted"], name: "index_monitoring_checks_on_deleted", using: :btree
  add_index "monitoring_checks", ["enabled"], name: "index_monitoring_checks_on_enabled", using: :btree
  add_index "monitoring_checks", ["long_id"], name: "index_monitoring_checks_on_long_id", unique: true, using: :btree
  add_index "monitoring_checks", ["muzzle_until"], name: "index_monitoring_checks_on_muzzle_until", using: :btree
  add_index "monitoring_checks", ["next_run_at"], name: "index_monitoring_checks_on_next_run_at", using: :btree
  add_index "monitoring_checks", ["server_id"], name: "index_monitoring_checks_on_server_id", using: :btree

  create_table "monitoring_notification_targets", force: :cascade do |t|
    t.integer "account_id",                        null: false
    t.integer "priority_mask",     default: 255,   null: false
    t.integer "target_type",                       null: false
    t.string  "target_value",                      null: false
    t.boolean "target_verified",   default: false, null: false
    t.string  "verification_code",                 null: false
  end

  add_index "monitoring_notification_targets", ["account_id"], name: "index_monitoring_notification_targets_on_account_id", using: :btree

  create_table "monitoring_notifications", force: :cascade do |t|
    t.integer  "check_id",                     null: false
    t.datetime "created_at",                   null: false
    t.datetime "resolved_at"
    t.string   "target_type",                  null: false
    t.string   "target_value",                 null: false
    t.string   "target_key"
    t.integer  "current_priority", default: 2
  end

  add_index "monitoring_notifications", ["check_id"], name: "index_monitoring_notifications_on_check_id", using: :btree
  add_index "monitoring_notifications", ["created_at"], name: "index_monitoring_notifications_on_created_at", using: :btree
  add_index "monitoring_notifications", ["resolved_at"], name: "index_monitoring_notifications_on_resolved_at", using: :btree

  create_table "monitoring_performance_metrics", force: :cascade do |t|
    t.integer "result_id",               null: false
    t.string  "key",                     null: false
    t.decimal "value",                   null: false
    t.decimal "warn",      default: 0.0
    t.decimal "crit",      default: 0.0
    t.decimal "min",       default: 0.0
    t.decimal "max",       default: 0.0
  end

  add_index "monitoring_performance_metrics", ["key"], name: "index_monitoring_performance_metrics_on_key", using: :btree
  add_index "monitoring_performance_metrics", ["result_id"], name: "index_monitoring_performance_metrics_on_result_id", using: :btree

  create_table "monitoring_results", force: :cascade do |t|
    t.integer  "check_id",      null: false
    t.decimal  "response_time", null: false
    t.string   "status"
    t.datetime "created_at",    null: false
    t.integer  "status_code",   null: false
  end

  add_index "monitoring_results", ["check_id"], name: "index_monitoring_results_on_check_id", using: :btree
  add_index "monitoring_results", ["created_at"], name: "index_monitoring_results_on_created_at", using: :btree

  create_table "orders_coupons", force: :cascade do |t|
    t.string   "coupon_code"
    t.decimal  "factor"
    t.integer  "status"
    t.datetime "expires_at"
    t.boolean  "published",   default: false
    t.datetime "begins_at"
  end

  add_index "orders_coupons", ["begins_at"], name: "index_orders_coupons_on_begins_at", using: :btree
  add_index "orders_coupons", ["coupon_code"], name: "index_orders_coupons_on_coupon_code", unique: true, using: :btree
  add_index "orders_coupons", ["expires_at"], name: "index_orders_coupons_on_expires_at", using: :btree
  add_index "orders_coupons", ["published"], name: "index_orders_coupons_on_published", using: :btree
  add_index "orders_coupons", ["status"], name: "index_orders_coupons_on_status", using: :btree

  create_table "service_notices", force: :cascade do |t|
    t.string "message"
  end

  create_table "sessions", force: :cascade do |t|
    t.string   "session_id", null: false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id", unique: true, using: :btree
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at", using: :btree

  create_table "solus_cluster_plans", force: :cascade do |t|
    t.integer "cluster_id"
    t.integer "plan_id"
  end

  add_index "solus_cluster_plans", ["cluster_id", "plan_id"], name: "index_solus_cluster_plans_on_cluster_id_and_plan_id", unique: true, using: :btree

  create_table "solus_clusters", force: :cascade do |t|
    t.string   "name"
    t.string   "hostname"
    t.string   "ip_address"
    t.string   "api_id"
    t.string   "api_secret"
    t.datetime "synchronized_at"
    t.string   "facility"
    t.string   "transit_providers"
  end

  create_table "solus_console_sessions", force: :cascade do |t|
    t.datetime "created_at"
    t.string   "ip_address"
    t.string   "target_hostname"
    t.integer  "target_port"
    t.datetime "updated_at"
  end

  add_index "solus_console_sessions", ["created_at"], name: "index_solus_console_sessions_on_created_at", using: :btree
  add_index "solus_console_sessions", ["ip_address"], name: "index_solus_console_sessions_on_ip_address", unique: true, using: :btree
  add_index "solus_console_sessions", ["updated_at"], name: "index_solus_console_sessions_on_updated_at", using: :btree

  create_table "solus_install_times", force: :cascade do |t|
    t.integer  "template_id"
    t.integer  "install_time"
    t.datetime "created_at"
  end

  add_index "solus_install_times", ["created_at"], name: "index_solus_install_times_on_created_at", using: :btree
  add_index "solus_install_times", ["template_id"], name: "index_solus_install_times_on_template_id", using: :btree

  create_table "solus_nodes", force: :cascade do |t|
    t.string   "name"
    t.string   "hostname"
    t.string   "ip_address"
    t.integer  "available_ram",   limit: 8
    t.integer  "available_disk",  limit: 8
    t.integer  "cluster_id"
    t.integer  "ram_limit",       limit: 8, default: 1
    t.integer  "allocated_ram",   limit: 8
    t.datetime "synchronized_at"
    t.integer  "disk_limit",      limit: 8, default: 1
    t.string   "node_group"
    t.boolean  "locked",                    default: false
    t.integer  "available_ipv4",            default: 0
    t.integer  "available_ipv6",            default: 0
  end

  add_index "solus_nodes", ["available_ipv4"], name: "index_solus_nodes_on_available_ipv4", using: :btree
  add_index "solus_nodes", ["available_ipv6"], name: "index_solus_nodes_on_available_ipv6", using: :btree
  add_index "solus_nodes", ["cluster_id"], name: "index_nodes_on_cluster_id", using: :btree
  add_index "solus_nodes", ["node_group"], name: "index_solus_nodes_on_node_group", using: :btree

  create_table "solus_plan_templates", force: :cascade do |t|
    t.integer "plan_id"
    t.integer "template_id"
  end

  add_index "solus_plan_templates", ["plan_id", "template_id"], name: "index_solus_plan_templates_on_plan_id_and_template_id", unique: true, using: :btree

  create_table "solus_plans", force: :cascade do |t|
    t.string  "name"
    t.string  "plan_part"
    t.integer "ram",            limit: 8
    t.integer "disk",           limit: 8
    t.integer "vcpus"
    t.integer "transfer",       limit: 8
    t.integer "ip_addresses"
    t.integer "amount"
    t.integer "status"
    t.integer "feature_status"
    t.integer "network_out"
    t.string  "node_group"
    t.string  "disk_type"
    t.integer "ipv6_addresses"
    t.boolean "managed",                  default: true
    t.boolean "legacy",                   default: false
  end

  add_index "solus_plans", ["feature_status"], name: "index_solus_plans_on_feature_status", using: :btree
  add_index "solus_plans", ["status"], name: "index_solus_plans_on_status", using: :btree

  create_table "solus_reverse_dns_mappings", force: :cascade do |t|
    t.string "cidr_prefix"
    t.string "record_suffix"
    t.string "zone_id"
  end

  create_table "solus_servers", force: :cascade do |t|
    t.string   "hostname"
    t.integer  "vserver_id"
    t.integer  "account_id"
    t.integer  "plan_id"
    t.integer  "node_id"
    t.integer  "template_id"
    t.string   "root_password"
    t.integer  "cluster_id"
    t.string   "state"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "amount"
    t.date     "next_due"
    t.date     "suspend_on"
    t.date     "terminate_on"
    t.string   "termination_reason"
    t.string   "suspension_reason"
    t.datetime "synchronize_at"
    t.string   "ip_address"
    t.integer  "used_transfer",           limit: 8, default: 0
    t.integer  "transfer",                limit: 8, default: 1
    t.integer  "disk",                    limit: 8, default: 0
    t.string   "long_id"
    t.integer  "coupon_id"
    t.integer  "visit_id"
    t.datetime "provision_started_at"
    t.datetime "provision_completed_at"
    t.string   "provision_id"
    t.date     "patch_at"
    t.integer  "patch_period"
    t.string   "patch_period_unit"
    t.integer  "plan_amount",                       default: 0
    t.integer  "template_amount",                   default: 0
    t.string   "xen_id"
    t.integer  "backup_user_id"
    t.boolean  "patch_out_of_band",                 default: false
    t.boolean  "enable_smtp",                       default: false
    t.text     "ip_address_list"
    t.boolean  "bypass_firewall",                   default: false
    t.datetime "synchronized_at"
    t.datetime "console_locked_until"
    t.integer  "console_locked_by_id"
    t.string   "console_lock_id"
    t.integer  "console_requested_by_id"
    t.string   "patch_incident_key"
  end

  add_index "solus_servers", ["account_id"], name: "index_servers_on_account_id", using: :btree
  add_index "solus_servers", ["backup_user_id"], name: "index_solus_servers_on_backup_user_id", using: :btree
  add_index "solus_servers", ["cluster_id"], name: "index_servers_on_cluster_id", using: :btree
  add_index "solus_servers", ["coupon_id"], name: "index_solus_servers_on_coupon_id", using: :btree
  add_index "solus_servers", ["ip_address"], name: "index_solus_servers_on_ip_address", using: :btree
  add_index "solus_servers", ["long_id"], name: "index_solus_servers_on_long_id", unique: true, using: :btree
  add_index "solus_servers", ["next_due"], name: "index_solus_servers_on_next_due", using: :btree
  add_index "solus_servers", ["node_id"], name: "index_servers_on_node_id", using: :btree
  add_index "solus_servers", ["patch_at"], name: "index_solus_servers_on_patch_at", using: :btree
  add_index "solus_servers", ["patch_out_of_band"], name: "index_solus_servers_on_patch_out_of_band", using: :btree
  add_index "solus_servers", ["plan_id"], name: "index_servers_on_plan_id", using: :btree
  add_index "solus_servers", ["state"], name: "index_solus_servers_on_state", using: :btree
  add_index "solus_servers", ["suspend_on"], name: "index_solus_servers_on_suspend_on", using: :btree
  add_index "solus_servers", ["template_id"], name: "index_servers_on_template_id", using: :btree
  add_index "solus_servers", ["terminate_on"], name: "index_solus_servers_on_terminate_on", using: :btree
  add_index "solus_servers", ["used_transfer"], name: "index_solus_servers_on_used_transfer", using: :btree
  add_index "solus_servers", ["visit_id"], name: "index_solus_servers_on_visit_id", using: :btree
  add_index "solus_servers", ["vserver_id"], name: "index_servers_on_vserver_id", unique: true, using: :btree

  create_table "solus_templates", force: :cascade do |t|
    t.string  "name"
    t.string  "plan_part"
    t.string  "template"
    t.string  "virtualization_type"
    t.string  "root_username"
    t.string  "description"
    t.integer "status"
    t.boolean "autocomplete_provision"
    t.integer "category",               default: 1
    t.integer "amount",                 default: 0
    t.string  "affinity_group"
    t.text    "preseed_template"
    t.boolean "generate_root_password", default: false
  end

  add_index "solus_templates", ["affinity_group"], name: "index_solus_templates_on_affinity_group", using: :btree
  add_index "solus_templates", ["status"], name: "index_solus_templates_on_status", using: :btree

  create_table "solus_usages", force: :cascade do |t|
    t.integer  "node_id"
    t.integer  "template_id"
    t.integer  "count"
    t.datetime "created_at"
  end

  add_index "solus_usages", ["count"], name: "index_solus_usages_on_count", using: :btree
  add_index "solus_usages", ["created_at"], name: "index_solus_usages_on_created_at", using: :btree
  add_index "solus_usages", ["node_id"], name: "index_solus_usages_on_node_id", using: :btree
  add_index "solus_usages", ["template_id"], name: "index_solus_usages_on_template_id", using: :btree

  create_table "taggings", force: :cascade do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["context"], name: "index_taggings_on_context", using: :btree
  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree
  add_index "taggings", ["tag_id"], name: "index_taggings_on_tag_id", using: :btree
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree
  add_index "taggings", ["taggable_id", "taggable_type", "tagger_id", "context"], name: "taggings_idy", using: :btree
  add_index "taggings", ["taggable_id"], name: "index_taggings_on_taggable_id", using: :btree
  add_index "taggings", ["taggable_type"], name: "index_taggings_on_taggable_type", using: :btree
  add_index "taggings", ["tagger_id", "tagger_type"], name: "index_taggings_on_tagger_id_and_tagger_type", using: :btree
  add_index "taggings", ["tagger_id"], name: "index_taggings_on_tagger_id", using: :btree

  create_table "tags", force: :cascade do |t|
    t.string  "name"
    t.integer "taggings_count", default: 0
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true, using: :btree

  create_table "tickets_tickets", force: :cascade do |t|
    t.integer  "account_id"
    t.string   "subject"
    t.integer  "status"
    t.integer  "priority"
    t.datetime "updated_at"
    t.string   "long_id"
    t.string   "incident_key"
    t.datetime "trigger_incident_at"
    t.string   "pagerduty_api_key"
  end

  add_index "tickets_tickets", ["account_id"], name: "index_tickets_on_account_id", using: :btree
  add_index "tickets_tickets", ["long_id"], name: "index_tickets_tickets_on_long_id", unique: true, using: :btree
  add_index "tickets_tickets", ["priority"], name: "index_tickets_on_priority", using: :btree
  add_index "tickets_tickets", ["status"], name: "index_tickets_on_state", using: :btree
  add_index "tickets_tickets", ["trigger_incident_at"], name: "index_tickets_tickets_on_trigger_incident_at", using: :btree
  add_index "tickets_tickets", ["updated_at"], name: "index_tickets_on_updated_at", using: :btree

  create_table "tickets_updates", force: :cascade do |t|
    t.integer  "ticket_id"
    t.integer  "user_id"
    t.text     "body"
    t.datetime "created_at"
    t.integer  "status"
    t.integer  "priority"
    t.integer  "sequence"
    t.text     "secure_body"
  end

  add_index "tickets_updates", ["sequence", "ticket_id"], name: "index_ticket_updates_on_sequence_and_ticket_id", unique: true, using: :btree
  add_index "tickets_updates", ["ticket_id"], name: "index_ticket_updates_on_ticket_id", using: :btree
  add_index "tickets_updates", ["user_id"], name: "index_ticket_updates_on_user_id", using: :btree

  create_table "users_email_log_entries", force: :cascade do |t|
    t.integer  "user_id",    null: false
    t.string   "to",         null: false
    t.datetime "created_at", null: false
    t.string   "subject",    null: false
    t.text     "body",       null: false
    t.string   "long_id"
  end

  add_index "users_email_log_entries", ["created_at"], name: "index_users_email_log_entries_on_created_at", using: :btree
  add_index "users_email_log_entries", ["long_id"], name: "index_users_email_log_entries_on_long_id", using: :btree
  add_index "users_email_log_entries", ["to"], name: "index_users_email_log_entries_on_to", using: :btree
  add_index "users_email_log_entries", ["user_id"], name: "index_users_email_log_entries_on_user_id", using: :btree

  create_table "users_enhanced_security_tokens", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "token"
    t.datetime "created_at"
    t.datetime "expires_at"
    t.boolean  "authorized",           default: false
    t.string   "authorization_code"
    t.datetime "last_seen_at"
    t.string   "long_id"
    t.string   "last_seen_ip_address"
    t.string   "user_agent"
  end

  add_index "users_enhanced_security_tokens", ["authorized"], name: "index_users_enhanced_security_tokens_on_authorized", using: :btree
  add_index "users_enhanced_security_tokens", ["created_at"], name: "index_users_enhanced_security_tokens_on_created_at", using: :btree
  add_index "users_enhanced_security_tokens", ["expires_at"], name: "index_users_enhanced_security_tokens_on_expires_at", using: :btree
  add_index "users_enhanced_security_tokens", ["long_id"], name: "index_users_enhanced_security_tokens_on_long_id", unique: true, using: :btree
  add_index "users_enhanced_security_tokens", ["token"], name: "index_users_enhanced_security_tokens_on_token", using: :btree
  add_index "users_enhanced_security_tokens", ["user_id", "token"], name: "index_users_enhanced_security_tokens_on_user_id_and_token", unique: true, using: :btree
  add_index "users_enhanced_security_tokens", ["user_id"], name: "index_users_enhanced_security_tokens_on_user_id", using: :btree

  create_table "users_events", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "message"
    t.string   "ip_address"
    t.string   "category"
    t.datetime "created_at"
  end

  add_index "users_events", ["category"], name: "index_users_events_on_category", using: :btree
  add_index "users_events", ["created_at"], name: "index_users_events_on_created_at", using: :btree
  add_index "users_events", ["user_id"], name: "index_users_events_on_user_id", using: :btree

  create_table "users_notifications", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "actor_id"
    t.integer  "target_id"
    t.string   "target_type"
    t.string   "message"
    t.string   "link_policy"
    t.datetime "created_at"
    t.boolean  "read",        default: false
  end

  add_index "users_notifications", ["actor_id"], name: "index_users_notifications_on_actor_id", using: :btree
  add_index "users_notifications", ["created_at"], name: "index_users_notifications_on_created_at", using: :btree
  add_index "users_notifications", ["read"], name: "index_users_notifications_on_read", using: :btree
  add_index "users_notifications", ["target_id", "target_type"], name: "index_users_notifications_on_target_id_and_target_type", using: :btree
  add_index "users_notifications", ["user_id"], name: "index_users_notifications_on_user_id", using: :btree

  create_table "users_profile_changes", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "email"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "phone"
    t.string   "security_question"
    t.string   "security_answer"
    t.datetime "created_at"
  end

  add_index "users_profile_changes", ["created_at"], name: "index_users_profile_changes_on_created_at", using: :btree
  add_index "users_profile_changes", ["email"], name: "index_users_profile_changes_on_email", using: :btree
  add_index "users_profile_changes", ["user_id"], name: "index_users_profile_changes_on_user_id", using: :btree

  create_table "users_tokens", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "token"
    t.string   "kind"
    t.datetime "expires_at"
  end

  add_index "users_tokens", ["expires_at"], name: "index_users_tokens_on_expires_at", using: :btree
  add_index "users_tokens", ["token", "kind"], name: "index_users_tokens_on_token_and_kind", unique: true, using: :btree
  add_index "users_tokens", ["user_id"], name: "index_users_tokens_on_user_id", using: :btree

  create_table "users_users", force: :cascade do |t|
    t.string   "email"
    t.string   "password_digest"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "security_question"
    t.string   "security_answer"
    t.string   "phone"
    t.string   "registration_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_staff"
    t.string   "otp_secret"
    t.datetime "session_generation"
    t.datetime "active_at"
    t.string   "state"
    t.boolean  "legal_accepted",                default: false
    t.boolean  "profile_complete",              default: false
    t.boolean  "email_confirmed",               default: false
    t.boolean  "enhanced_security",             default: true
    t.boolean  "receive_security_bulletins",    default: true
    t.boolean  "receive_product_announcements", default: true
  end

  add_index "users_users", ["active_at"], name: "index_users_users_on_active_at", using: :btree
  add_index "users_users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users_users", ["email_confirmed"], name: "index_users_users_on_email_confirmed", using: :btree
  add_index "users_users", ["is_staff"], name: "index_users_on_is_staff", using: :btree
  add_index "users_users", ["profile_complete"], name: "index_users_users_on_profile_complete", using: :btree
  add_index "users_users", ["receive_product_announcements"], name: "index_users_users_on_receive_product_announcements", using: :btree
  add_index "users_users", ["receive_security_bulletins"], name: "index_users_users_on_receive_security_bulletins", using: :btree
  add_index "users_users", ["state"], name: "index_users_users_on_state", using: :btree

end
