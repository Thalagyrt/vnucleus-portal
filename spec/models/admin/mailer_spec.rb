require 'spec_helper'

describe Admin::Mailer do
  let(:user) { create :user }
  let(:account) { create :account }

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

    it "contains the body of the ticket update" do
      expect(mail.body.encoded).to match(ticket_update.body)
    end
  end

  describe 'server_confirmed' do
    let(:server) { create :solus_server }
    let(:mail) { described_class.server_confirmed(user: user, server: server) }

    it "renders the subject" do
      expect(mail.subject).to eq("New Order: Server #{server.to_s}")
    end

    it "has the correct sender email" do
      expect(mail.from).to eq(['noreply@vnucleus.com'])
    end

    it "has the correct recipient" do
      expect(mail.to).to eq([user.email])
    end

    it "contains the server hostname" do
      expect(mail.body.encoded).to match(server.hostname)
    end
  end

  describe 'server_terminated' do
    let(:server) { create :solus_server }
    let(:mail) { described_class.server_terminated(user: user, server: server) }

    it "renders the subject" do
      expect(mail.subject).to eq("Server Terminated: Server #{server.to_s}")
    end

    it "has the correct sender email" do
      expect(mail.from).to eq(['noreply@vnucleus.com'])
    end

    it "has the correct recipient" do
      expect(mail.to).to eq([user.email])
    end

    it "contains the server hostname" do
      expect(mail.body.encoded).to match(server.hostname)
    end
  end

  describe 'provision_stalled' do
    let(:server) { create :solus_server }
    let(:mail) { described_class.provision_stalled(user: user, server: server) }

    it "renders the subject" do
      expect(mail.subject).to eq("Provision Stalled: Server #{server.to_s}")
    end

    it "has the correct sender email" do
      expect(mail.from).to eq(['noreply@vnucleus.com'])
    end

    it "has the correct recipient" do
      expect(mail.to).to eq([user.email])
    end

    it "contains the server hostname" do
      expect(mail.body.encoded).to match(server.hostname)
    end
  end

  describe 'login_failed' do
    let(:failed_user) { create :user }

    let(:mail) { described_class.login_failed(user: user, failed_user: failed_user, ip_address: '127.0.0.1') }

    it "renders the subject" do
      expect(mail.subject).to eq("Failed login for #{failed_user.email} from 127.0.0.1")
    end

    it "has the correct sender email" do
      expect(mail.from).to eq(['noreply@vnucleus.com'])
    end

    it "has the correct recipient" do
      expect(mail.to).to eq([user.email])
    end

    it "contains the failed user's email address" do
      expect(mail.body.encoded).to match(failed_user.email)
    end

    it "contains the IP address" do
      expect(mail.body.encoded).to match("127.0.0.1")
    end
  end

  describe 'account_pending_activation' do
    let(:account) { create :account }
    let(:mail) { described_class.account_pending_activation(user: user, account: account) }

    it "renders the subject" do
      expect(mail.subject).to eq("Account pending manual activation")
    end

    it "has the correct sender email" do
      expect(mail.from).to eq(['noreply@vnucleus.com'])
    end

    it "has the correct recipient" do
      expect(mail.to).to eq([user.email])
    end
  end
end
