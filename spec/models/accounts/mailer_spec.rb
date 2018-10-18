require 'spec_helper'

describe Accounts::Mailer do
  let(:user) { create :user_with_account }
  let(:account) { user.accounts.first }

  describe 'ticket_created' do
    let(:ticket) { create :ticket, account: account }
    let!(:ticket_update) { create :ticket_update, ticket: ticket, user: user }
    let(:mail) { described_class.ticket_created(user: user, ticket: ticket) }

    it "renders the subject" do
      expect(mail.subject).to eq("[#{ticket.to_param}] #{ticket.subject}")
    end

    it "has the correct sender email" do
      expect(mail.from).to eq(['noreply@vnucleus.com'])
    end

    it "has the correct recipient" do
      expect(mail.to).to eq([user.email])
    end

    it "greets the user by name" do
      expect(mail.body.encoded).to match(user.first_name)
    end

    it "contains the body of the first ticket update" do
      expect(mail.body.encoded).to match(ticket_update.body)
    end
  end

  describe 'ticket_updated' do
    let(:ticket) { create :ticket, account: account }
    let!(:ticket_update) { create :ticket_update, ticket: ticket, user: user }
    let(:mail) { described_class.ticket_updated(user: user, update: ticket_update) }

    it "renders the subject" do
      expect(mail.subject).to eq("Re: [#{ticket.to_param}] #{ticket.subject}")
    end

    it "has the correct sender email" do
      expect(mail.from).to eq(['noreply@vnucleus.com'])
    end

    it "has the correct recipient" do
      expect(mail.to).to eq([user.email])
    end

    it "greets the user by name" do
      expect(mail.body.encoded).to match(user.first_name)
    end

    it "contains the body of the ticket update" do
      expect(mail.body.encoded).to match(ticket_update.body)
    end
  end

  describe 'server_confirmed' do
    let(:server) { create :solus_server }
    let(:mail) { described_class.server_confirmed(user: user, account: account, server: server) }

    it "renders the subject" do
      expect(mail.subject).to eq("Your order confirmation for server #{server.to_s}")
    end

    it "has the correct sender email" do
      expect(mail.from).to eq(['noreply@vnucleus.com'])
    end

    it "has the correct recipient" do
      expect(mail.to).to eq([user.email])
    end

    it "greets the user by name" do
      expect(mail.body.encoded).to match(user.first_name)
    end

    it "contains the server hostname" do
      expect(mail.body.encoded).to match(server.hostname)
    end
  end

  describe 'server_provisioned' do
    let(:server) { create :solus_server }
    let(:mail) { described_class.server_provisioned(user: user, account: account, server: server) }

    it "renders the subject" do
      expect(mail.subject).to eq("Server #{server.to_s} has been provisioned")
    end

    it "has the correct sender email" do
      expect(mail.from).to eq(['noreply@vnucleus.com'])
    end

    it "has the correct recipient" do
      expect(mail.to).to eq([user.email])
    end

    it "greets the user by name" do
      expect(mail.body.encoded).to match(user.first_name)
    end

    it "contains the server hostname" do
      expect(mail.body.encoded).to match(server.hostname)
    end
  end

  describe 'server_suspended' do
    let(:server) { create :solus_server }
    let(:mail) { described_class.server_suspended(user: user, account: account, server: server) }

    it "renders the subject" do
      expect(mail.subject).to eq("Server #{server.to_s} has been suspended")
    end

    it "has the correct sender email" do
      expect(mail.from).to eq(['noreply@vnucleus.com'])
    end

    it "has the correct recipient" do
      expect(mail.to).to eq([user.email])
    end

    it "greets the user by name" do
      expect(mail.body.encoded).to match(user.first_name)
    end

    it "contains the server hostname" do
      expect(mail.body.encoded).to match(server.hostname)
    end
  end

  describe 'server_unsuspended' do
    let(:server) { create :solus_server }
    let(:mail) { described_class.server_unsuspended(user: user, account: account, server: server) }

    it "renders the subject" do
      expect(mail.subject).to eq("Server #{server.to_s} has been unsuspended")
    end

    it "has the correct sender email" do
      expect(mail.from).to eq(['noreply@vnucleus.com'])
    end

    it "has the correct recipient" do
      expect(mail.to).to eq([user.email])
    end

    it "greets the user by name" do
      expect(mail.body.encoded).to match(user.first_name)
    end

    it "contains the server hostname" do
      expect(mail.body.encoded).to match(server.hostname)
    end
  end

  describe 'server_terminated' do
    let(:server) { create :solus_server, termination_reason: "Non-Payment" }
    let(:mail) { described_class.server_terminated(user: user, account: account, server: server) }

    it "renders the subject" do
      expect(mail.subject).to eq("Server #{server.to_s} has been terminated")
    end

    it "has the correct sender email" do
      expect(mail.from).to eq(['noreply@vnucleus.com'])
    end

    it "has the correct recipient" do
      expect(mail.to).to eq([user.email])
    end

    it "greets the user by name" do
      expect(mail.body.encoded).to match(user.first_name)
    end

    it "contains the termination reason" do
      expect(mail.body.encoded).to match(server.termination_reason)
    end
  end

  describe 'transfer_notification' do
    let(:server) { create :solus_server, state: :active }
    let(:mail) { described_class.transfer_notification(user: user, account: account, server: server) }

    it "renders the subject" do
      expect(mail.subject).to eq("Server #{server.to_s} is approaching its bandwidth limit")
    end

    it "has the correct sender email" do
      expect(mail.from).to eq(['noreply@vnucleus.com'])
    end

    it "has the correct recipient" do
      expect(mail.to).to eq([user.email])
    end

    it "greets the user by name" do
      expect(mail.body.encoded).to match(user.first_name)
    end
  end

  describe 'transactions_posted' do
    let(:transaction) { create :transaction, account: account, amount: 995 }
    let(:mail) { described_class.transactions_posted(user: user, account: account, transactions: [transaction]) }

    it "renders the subject" do
      expect(mail.subject).to eq("New transactions have posted to your account")
    end

    it "has the correct sender email" do
      expect(mail.from).to eq(['noreply@vnucleus.com'])
    end

    it "has the correct recipient" do
      expect(mail.to).to eq([user.email])
    end

    it "greets the user by name" do
      expect(mail.body.encoded).to match(user.first_name)
    end

    it "contains the transaction's amount" do
      expect(mail.body.encoded).to match(/\$9.95/)
    end

    it "contains the transaction's description" do
      expect(mail.body.encoded).to match(transaction.description)
    end
  end

  describe 'payment_received' do
    let(:transaction) { create :transaction, account: account, amount: 995 }
    let(:mail) { described_class.payment_received(user: user, account: account, transaction: transaction) }

    it "renders the subject" do
      expect(mail.subject).to eq("Thank you for your payment!")
    end

    it "has the correct sender email" do
      expect(mail.from).to eq(['noreply@vnucleus.com'])
    end

    it "has the correct recipient" do
      expect(mail.to).to eq([user.email])
    end

    it "greets the user by name" do
      expect(mail.body.encoded).to match(user.first_name)
    end

    it "contains the transaction's amount" do
      expect(mail.body.encoded).to match(/\$9.95/)
    end

    it "contains the transaction's reference" do
      expect(mail.body.encoded).to match(transaction.reference)
    end
  end

  describe 'payment_failed' do
    let(:amount) { 500 }
    let(:mail) { described_class.payment_failed(user: user, account: account, amount: amount) }

    it "renders the subject" do
      expect(mail.subject).to eq("A recent payment on your account has failed")
    end

    it "has the correct sender email" do
      expect(mail.from).to eq(['noreply@vnucleus.com'])
    end

    it "has the correct recipient" do
      expect(mail.to).to eq([user.email])
    end

    it "greets the user by name" do
      expect(mail.body.encoded).to match(user.first_name)
    end

    it "contains the amount attempted" do
      expect(mail.body.encoded).to match(/\$5.00/)
    end
  end

  describe 'credit_card_expiring' do
    let(:mail) { described_class.credit_card_expiring(user: user, account: account) }

    it "renders the subject" do
      expect(mail.subject).to eq("Your credit card is expiring soon")
    end

    it "has the correct sender email" do
      expect(mail.from).to eq(['noreply@vnucleus.com'])
    end

    it "has the correct recipient" do
      expect(mail.to).to eq([user.email])
    end

    it "greets the user by name" do
      expect(mail.body.encoded).to match(user.first_name)
    end
  end

  describe 'new_credit_card_found' do
    let(:mail) { described_class.new_credit_card_found(user: user, account: account) }

    it "renders the subject" do
      expect(mail.subject).to eq("We've updated your credit card")
    end

    it "has the correct sender email" do
      expect(mail.from).to eq(['noreply@vnucleus.com'])
    end

    it "has the correct recipient" do
      expect(mail.to).to eq([user.email])
    end

    it "greets the user by name" do
      expect(mail.body.encoded).to match(user.first_name)
    end
  end

  describe 'credit_card_removed' do
    let(:mail) { described_class.credit_card_removed(user: user, account: account) }

    it "renders the subject" do
      expect(mail.subject).to eq("Your credit card has been removed")
    end

    it "has the correct sender email" do
      expect(mail.from).to eq(['noreply@vnucleus.com'])
    end

    it "has the correct recipient" do
      expect(mail.to).to eq([user.email])
    end

    it "greets the user by name" do
      expect(mail.body.encoded).to match(user.first_name)
    end
  end

  describe 'account_activated' do
    let(:mail) { described_class.account_activated(user: user, account: account) }

    it "renders the subject" do
      expect(mail.subject).to eq("Your account has been activated")
    end

    it "has the correct sender email" do
      expect(mail.from).to eq(['noreply@vnucleus.com'])
    end

    it "has the correct recipient" do
      expect(mail.to).to eq([user.email])
    end

    it "greets the user by name" do
      expect(mail.body.encoded).to match(user.first_name)
    end
  end

  describe 'account_rejected' do
    let(:mail) { described_class.account_rejected(user: user, account: account) }

    it "renders the subject" do
      expect(mail.subject).to eq("Your account could not be activated")
    end

    it "has the correct sender email" do
      expect(mail.from).to eq(['noreply@vnucleus.com'])
    end

    it "has the correct recipient" do
      expect(mail.to).to eq([user.email])
    end

    it "greets the user by name" do
      expect(mail.body.encoded).to match(user.first_name)
    end
  end
end
