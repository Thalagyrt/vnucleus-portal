require 'spec_helper'

describe Accounts::MailerService do
  let(:full_control_user) { create :user }
  let(:server_only_user) { create :user }
  let(:billing_only_user) { create :user }
  let(:users) { [full_control_user, server_only_user, billing_only_user] }
  let(:account) { create :account }
  let(:mailer) { double :mailer }
  subject { described_class.new(account: account, mailer: mailer) }

  before do
    account.memberships.create(user: full_control_user, roles: :full_control)
    account.memberships.create(user: server_only_user, roles: :manage_servers)
    account.memberships.create(user: billing_only_user, roles: :manage_billing)
  end

  describe "#ticket_created" do
    let(:ticket) { double :ticket }

    it "emails the account users" do
      users.each do |user|
        expect(mailer).to receive(:ticket_created).with(hash_including(user: user, ticket: ticket))
      end

      subject.ticket_created(ticket: ticket)
    end
  end

  describe "#ticket_updated" do
    let(:ticket_update) { double :ticket_update }

    it "emails the account users" do
      users.each do |user|
        expect(mailer).to receive(:ticket_updated).with(hash_including(user: user, update: ticket_update))
      end

      subject.ticket_updated(update: ticket_update)
    end
  end

  describe "#account_activated" do
    it "emails the account users" do
      users.each do |user|
        expect(mailer).to receive(:account_activated).with(hash_including(user: user))
      end

      subject.account_activated
    end
  end

  describe "#account_rejected" do
    it "emails the account users" do
      users.each do |user|
        expect(mailer).to receive(:account_rejected).with(hash_including(user: user))
      end

      subject.account_rejected
    end
  end

  describe "#server_confirmed" do
    let(:server) { double :server, account: account }

    it "emails the account users" do
      expect(mailer).to receive(:server_confirmed).with(hash_including(user: full_control_user, server: server))
      expect(mailer).to receive(:server_confirmed).with(hash_including(user: server_only_user, server: server))
      expect(mailer).to_not receive(:server_confirmed).with(hash_including(user: billing_only_user, server: server))

      subject.server_confirmed(server: server)
    end
  end

  describe "#server_provisioned" do
    let(:server) { double :server, account: account }

    it "emails the account users" do
      expect(mailer).to receive(:server_provisioned).with(hash_including(user: full_control_user, server: server))
      expect(mailer).to receive(:server_provisioned).with(hash_including(user: server_only_user, server: server))
      expect(mailer).to_not receive(:server_provisioned).with(hash_including(user: billing_only_user, server: server))

      subject.server_provisioned(server: server)
    end
  end

  describe "#server_suspended" do
    let(:server) { double :server, account: account }

    it "emails the account users" do
      expect(mailer).to receive(:server_suspended).with(hash_including(user: full_control_user, server: server))
      expect(mailer).to receive(:server_suspended).with(hash_including(user: server_only_user, server: server))
      expect(mailer).to_not receive(:server_suspended).with(hash_including(user: billing_only_user, server: server))

      subject.server_suspended(server: server)
    end
  end

  describe "#server_unsuspended" do
    let(:server) { double :server, account: account }

    it "emails the account users" do
      expect(mailer).to receive(:server_unsuspended).with(hash_including(user: full_control_user, server: server))
      expect(mailer).to receive(:server_unsuspended).with(hash_including(user: server_only_user, server: server))
      expect(mailer).to_not receive(:server_unsuspended).with(hash_including(user: billing_only_user, server: server))

      subject.server_unsuspended(server: server)
    end
  end

  describe "#server_terminated" do
    let(:server) { double :server, account: account }

    it "emails the account users" do
      expect(mailer).to receive(:server_terminated).with(hash_including(user: full_control_user, server: server))
      expect(mailer).to receive(:server_terminated).with(hash_including(user: server_only_user, server: server))
      expect(mailer).to_not receive(:server_terminated).with(hash_including(user: billing_only_user, server: server))

      subject.server_terminated(server: server)
    end
  end

  describe "#transactions_posted" do
    let(:server) { double :server, account: account }
    let(:transactions) { [double(:transaction)] }

    it "emails the account users" do
      expect(mailer).to receive(:transactions_posted).with(hash_including(user: full_control_user, account: account, transactions: transactions))
      expect(mailer).to_not receive(:transactions_posted).with(hash_including(user: server_only_user, account: account, transactions: transactions))
      expect(mailer).to receive(:transactions_posted).with(hash_including(user: billing_only_user, account: account, transactions: transactions))

      subject.transactions_posted(transactions: transactions)
    end
  end

  describe "#payment_received" do
    let(:server) { double :server, account: account }
    let(:transaction) { double(:transaction) }

    it "emails the account users" do
      expect(mailer).to receive(:payment_received).with(hash_including(user: full_control_user, account: account, transaction: transaction))
      expect(mailer).to_not receive(:payment_received).with(hash_including(user: server_only_user, account: account, transaction: transaction))
      expect(mailer).to receive(:payment_received).with(hash_including(user: billing_only_user, account: account, transaction: transaction))

      subject.payment_received(transaction: transaction)
    end
  end

  describe "#transfer_notification" do
    let(:server) { double :server, account: account }

    it "emails the account users" do
      expect(mailer).to receive(:transfer_notification).with(hash_including(user: full_control_user, account: account, server: server))
      expect(mailer).to_not receive(:transfer_notification).with(hash_including(user: server_only_user, account: account, server: server))
      expect(mailer).to receive(:transfer_notification).with(hash_including(user: billing_only_user, account: account, server: server))

      subject.transfer_notification(server: server)
    end
  end

  describe "#payment_failed" do
    let(:server) { double :server, account: account }
    let(:amount) { 500 }

    it "emails the account users" do
      expect(mailer).to receive(:payment_failed).with(hash_including(user: full_control_user, account: account, amount: amount))
      expect(mailer).to_not receive(:payment_failed).with(hash_including(user: server_only_user, account: account, amount: amount))
      expect(mailer).to receive(:payment_failed).with(hash_including(user: billing_only_user, account: account, amount: amount))

      subject.payment_failed(amount: amount)
    end
  end

  describe "#credit_card_expiring" do
    let(:server) { double :server, account: account }

    it "emails the account users" do
      expect(mailer).to receive(:credit_card_expiring).with(hash_including(user: full_control_user, account: account))
      expect(mailer).to_not receive(:credit_card_expiring).with(hash_including(user: server_only_user, account: account))
      expect(mailer).to receive(:credit_card_expiring).with(hash_including(user: billing_only_user, account: account))

      subject.credit_card_expiring
    end
  end

  describe "#new_credit_card_found" do
    let(:server) { double :server, account: account }

    it "emails the account users" do
      expect(mailer).to receive(:new_credit_card_found).with(hash_including(user: full_control_user, account: account))
      expect(mailer).to_not receive(:new_credit_card_found).with(hash_including(user: server_only_user, account: account))
      expect(mailer).to receive(:new_credit_card_found).with(hash_including(user: billing_only_user, account: account))

      subject.new_credit_card_found
    end
  end

  describe "#credit_card_removed" do
    let(:server) { double :server, account: account }

    it "emails the account users" do
      expect(mailer).to receive(:credit_card_removed).with(hash_including(user: full_control_user, account: account))
      expect(mailer).to_not receive(:credit_card_removed).with(hash_including(user: server_only_user, account: account))
      expect(mailer).to receive(:credit_card_removed).with(hash_including(user: billing_only_user, account: account))

      subject.credit_card_removed
    end
  end
end