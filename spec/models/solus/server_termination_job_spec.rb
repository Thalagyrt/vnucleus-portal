require 'spec_helper'

describe Solus::ServerTerminationJob do
  let(:account) { double(:account) }
  let(:server) { double(:server, id: 1, prorated_amount: 100, next_due: Time.zone.today + 7.days, account: account, description: 'Server #1 (testy)') }
  let(:server_termination_service) { double(:server_termination_service) }
  let(:mailer_service) { double(:mailer_service) }
  let(:admin_mailer_service) { double(:admin_mailer_service) }

  subject do
    described_class.new(
        server: server,
        server_termination_service: server_termination_service,
        mailer_service: mailer_service,
        admin_mailer_service: admin_mailer_service,
    )
  end

  context "when the server can be cancelled" do
    before { allow(server_termination_service).to receive(:terminate).and_return(true) }
    before { allow(mailer_service).to receive(:server_terminated) }
    before { allow(admin_mailer_service).to receive(:server_terminated) }

    it "terminates the server" do
      expect(server_termination_service).to receive(:terminate)

      subject.perform
    end

    it "sends the goodbye email" do
      expect(mailer_service).to receive(:server_terminated).with(hash_including(server: server))

      subject.perform
    end

    it "notifies the admins" do
      expect(admin_mailer_service).to receive(:server_terminated).with(hash_including(server: server))

      subject.perform
    end
  end
end