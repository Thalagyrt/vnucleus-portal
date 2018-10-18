require 'spec_helper'

describe Admin::MailerService do
  let(:users) { [double(:user_1), double(:user_2), double(:user_3)] }
  let(:mailer) { double :mailer }
  subject { described_class.new(mailer: mailer) }
  before { allow(Users::User).to receive(:staff).and_return(users) }

  describe "#ticket_created" do
    let(:ticket) { double :ticket }

    it "emails the staff users" do
      users.each do |user|
        expect(mailer).to receive(:ticket_created).with(hash_including(user: user, ticket: ticket))
      end

      subject.ticket_created(ticket: ticket)
    end
  end

  describe "#ticket_updated" do
    let(:ticket_update) { double :ticket_update }

    it "emails the staff users" do
      users.each do |user|
        expect(mailer).to receive(:ticket_updated).with(hash_including(user: user, update: ticket_update))
      end

      subject.ticket_updated(update: ticket_update)
    end
  end

  describe "#server_confirmed" do
    let(:server) { double :server }

    it "emails the staff users" do
      users.each do |user|
        expect(mailer).to receive(:server_confirmed).with(hash_including(user: user, server: server))
      end

      subject.server_confirmed(server: server)
    end
  end

  describe "#server_terminated" do
    let(:server) { double :server }

    it "emails the staff users" do
      users.each do |user|
        expect(mailer).to receive(:server_terminated).with(hash_including(user: user, server: server))
      end

      subject.server_terminated(server: server)
    end
  end

  describe "#provision_stalled" do
    let(:server) { double :server }

    it "emails the staff users" do
      users.each do |user|
        expect(mailer).to receive(:provision_stalled).with(hash_including(user: user, server: server))
      end

      subject.provision_stalled(server: server)
    end
  end

  describe "#login_failed" do
    let(:ip_address) { double(:ip_address) }
    let(:failed_user) { double(:failed_user) }

    it "emails the staff users" do
      users.each do |user|
        expect(mailer).to receive(:login_failed).with(hash_including(user: user, failed_user: failed_user, ip_address: ip_address))
      end

      subject.login_failed(failed_user: failed_user, ip_address: ip_address)
    end
  end

  describe "#account_pending_activation" do
    let(:account) { double :account }

    it "emails the staff users" do
      users.each do |user|
        expect(mailer).to receive(:account_pending_activation).with(hash_including(user: user, account: account))
      end

      subject.account_pending_activation(account: account)
    end
  end
end