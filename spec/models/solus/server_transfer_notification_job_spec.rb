require 'spec_helper'

describe Solus::ServerTransferNotificationJob do
  let(:server) { double(:server, id: 1) }
  let(:event_logger) { double(:event_logger) }
  let(:mailer_service) { double(:mailer_service) }

  subject do
    described_class.new(
        server: server,
        event_logger: event_logger,
        mailer_service: mailer_service,
    )
  end

  before { allow(mailer_service).to receive(:transfer_notification) }
  before { allow(event_logger).to receive(:log) }

  it "logs the notification" do
    expect(event_logger).to receive(:log).with(:transfer_notification_sent)

    subject.perform
  end

  it "sends the warning email" do
    expect(mailer_service).to receive(:transfer_notification).with(hash_including(server: server))

    subject.perform
  end
end