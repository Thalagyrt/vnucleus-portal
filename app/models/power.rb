class Power
  include Consul::Power

  SERVER_ACCESS_ROLES = [:full_control, :manage_servers]
  BILLING_ACCESS_ROLES = [:full_control, :manage_billing]

  def initialize(user)
    self.user = user
  end

  ##### FRONTEND

  power :knowledge_base_articles do
    KnowledgeBase::Article.published
  end

  power :blog_posts do
    Blog::Post.published
  end

  ##### USERS

  power :user_accounts do
    user.accounts
  end

  power :user_notifications do
    user.notifications
  end

  power :user_invites do
    Accounts::Invite.active
  end

  power :user_enhanced_security_tokens do
    user.enhanced_security_tokens
  end

  power :user_email_log_entries do
    user.email_log_entries
  end

  power :user_solus_plans do
    if user.is_staff?
      Solus::Plan.not_hidden
    else
      Solus::Plan.active
    end
  end

  power :user_solus_cluster_plans do |cluster|
    if user.is_staff?
      cluster.plans.not_hidden
    else
      cluster.plans.active
    end
  end

  power :user_solus_plan_templates do |plan|
    plan.templates.active
  end

  ##### ACCOUNTS

  power :account_full_access do |account|
    with_account_role(account, :full_control) { true }
  end

  power :account_billing_access do |account|
    with_account_role(account, *BILLING_ACCESS_ROLES) { true }
  end

  power :account_server_access do |account|
    with_account_role(account, *SERVER_ACCESS_ROLES) { true }
  end

  power :account_affiliates do |account|
    if account.active?
      with_full_access(account) do
        account.affiliate_enabled?
      end
    end
  end

  power :account_tickets do |account|
    with_account_access(account) { account.tickets }
  end

  power :creatable_account_tickets do |account|
    return unless user.email_confirmed?

    if account.current?
      account_tickets(account)
    end
  end

  power :updatable_account_tickets do |account|
    if account.current?
      account_tickets(account)
    end
  end

  power :account_licenses do |account|
    with_account_access(account) do
      if account.licenses.present?
        account.licenses
      end
    end
  end

  power :account_credit_card do |account|
    return unless user.legal_accepted?
    return unless user.profile_complete?
    return unless user.email_confirmed?

    if account.active? || account.pending_billing_information?
      with_billing_access(account) { true }
    end
  end

  power :account_transactions do |account|
    with_billing_access(account) { account.transactions }
  end

  power :account_payments do |account|
    return unless account.active?

    with_billing_access(account) { true }
  end

  power :account_monitoring_checks do |account|
    with_server_access(account) { account.monitoring_checks.exclude_deleted }
  end

  power :account_solus_servers do |account|
    with_server_access(account) { account.solus_servers }
  end

  power :creatable_account_solus_servers do |account|
    if account.active? && Rails.application.config.accept_orders
      account_solus_servers(account)
    end
  end

  power :confirmable_account_solus_servers do |account|
    return unless Rails.application.config.accept_orders
    return unless user.legal_accepted?
    return unless user.profile_complete?
    return unless user.email_confirmed?

    if account.active? && account.credit_card_valid?
      account_solus_servers(account)
    end
  end

  power :account_solus_server_monitoring_checks do |server|
    with_server_access(server.account) { server.monitoring_checks.exclude_deleted }
  end

  power :account_dedicated_servers do |account|
    with_server_access(account) { account.dedicated_servers }
  end

  power :account_events do |account|
    with_full_access(account) { account.events }
  end

  power :account_invites do |account|
    if account.active?
      with_full_access(account) { account.invites }
    end
  end

  power :account_memberships do |account|
    if account.active?
      with_full_access(account) { account.memberships }
    end
  end

  power :updatable_account_memberships do |account|
    if account.active?
      with_full_access(account) { account.memberships.where('user_id <> ?', user.id) }
    end
  end

  ##### ADMIN

  power :admin_knowledge_base_articles do
    with_admin_rights { KnowledgeBase::Article.all }
  end

  power :admin_service_notices do
    with_admin_rights { Service::Notice.all }
  end

  power :admin_communications_announcements do
    with_admin_rights { Communications::Announcement.all }
  end

  power :updatable_admin_communications_announcements do
    with_admin_rights { Communications::Announcement.find_unsent }
  end

  power :admin_monitoring_checks do
    with_admin_rights { Monitoring::Check.exclude_deleted }
  end

  power :admin_blog_posts do
    with_admin_rights { Blog::Post.all }
  end

  power :admin_licenses do
    with_admin_rights { Licenses::License.all }
  end

  power :admin_license_usages do
    with_admin_rights { Licenses::Usage.all }
  end

  power :admin_license_products do
    with_admin_rights { Licenses::Product.all }
  end

  power :admin_leads do
    with_admin_rights { Leads::Lead.all }
  end

  power :admin_visits do
    with_admin_rights { Ahoy::Visit.all }
  end

  power :admin_email_log_entries do
    with_admin_rights { Users::EmailLogEntry.all }
  end

  power :admin_users do
    with_admin_rights { Users::User.all }
  end

  power :admin_user_visits do |user|
    with_admin_rights { user.visits }
  end

  power :admin_user_email_log_entries do |user|
    with_admin_rights { user.email_log_entries }
  end

  power :admin_tickets do
    with_admin_rights { Tickets::Ticket.all }
  end

  power :admin_accounts do
    with_admin_rights { Accounts::Account.all }
  end

  power :admin_account_backup_users do |account|
    with_admin_rights { account.backup_users }
  end

  power :admin_account_licenses do |account|
    with_admin_rights { account.licenses }
  end

  power :admin_account_credit_card do |account|
    if account.current?
      with_admin_rights { true }
    end
  end

  power :admin_transactions do
    with_admin_rights { Accounts::Transaction.all }
  end

  power :admin_solus_servers do
    with_admin_rights { Solus::Server.all }
  end

  power :admin_solus_clusters do
    with_admin_rights { Solus::Cluster.all }
  end

  power :admin_solus_plans do
    with_admin_rights { Solus::Plan.all }
  end

  power :admin_solus_usages do
    with_admin_rights { Solus::Usage.all }
  end

  power :admin_solus_templates do
    with_admin_rights { Solus::Template.all }
  end

  power :admin_dedicated_servers do
    with_admin_rights { Dedicated::Server.all }
  end

  power :admin_account_solus_servers do |account|
    with_admin_rights { account.solus_servers }
  end

  power :creatable_admin_account_solus_servers do |account|
    if account.active?
      admin_account_solus_servers(account)
    end
  end

  power :updatable_admin_account_solus_servers do |account|
    if account.active?
      admin_account_solus_servers(account)
    end
  end

  power :admin_account_solus_server_monitoring_checks do |server|
    with_admin_rights { server.monitoring_checks.exclude_deleted }
  end

  power :admin_account_dedicated_servers do |account|
    with_admin_rights { account.dedicated_servers }
  end

  power :admin_account_tickets do |account|
    with_admin_rights { account.tickets }
  end

  power :creatable_admin_account_tickets do |account|
    if account.current?
      admin_account_tickets(account)
    end
  end

  power :updatable_admin_account_tickets do |account|
    if account.current?
      admin_account_tickets(account)
    end
  end

  power :admin_account_transactions do |account|
    with_admin_rights { account.transactions }
  end

  power :creatable_admin_account_transactions do |account|
    if account.active?
      admin_account_transactions(account)
    end
  end

  power :admin_account_events do |account|
    with_admin_rights { account.events }
  end

  power :admin_account_notes do |account|
    with_admin_rights { account.notes }
  end

  power :admin_account_memberships do |account|
    with_admin_rights { account.memberships }
  end

  power :assignable_tickets_update_statuses do
    statuses = ::Concerns::Tickets::TicketStatusModelConcern::CLIENT_STATUSES
    with_admin_rights { statuses |= ::Concerns::Tickets::TicketStatusModelConcern::STAFF_STATUSES }
    statuses
  end

  private
  attr_accessor :user

  def with_full_access(account)
    yield if account_full_access?(account)
  end

  def with_billing_access(account)
    yield if account_billing_access?(account)
  end

  def with_server_access(account)
    yield if account_server_access?(account)
  end

  def with_account_access(account)
    account_user = account.memberships.where(user_id: user.id).first

    yield account_user if account_user
  end

  def with_account_role(account, *roles)
    with_account_access(account) do |account_user|
      yield if account_user.has_any_role?(roles)
    end
  end

  def with_admin_rights
    yield if user.is_staff?
  end
end