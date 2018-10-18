require 'spec_helper'

describe Accounts::CreditCardExpirationJob do
  let(:account) { double(:account) }
  let(:mailer_service) { double(:mailer_service) }
  let(:event_logger) { double(:event_logger) }
  subject { described_class.new(account: account, mailer_service: mailer_service, event_logger: event_logger) }

  before { allow(event_logger).to receive(:log) }
  before { allow(mailer_service).to receive(:credit_card_expiring) }

  it "adds an event log entry" do
    expect(event_logger).to receive(:log).with(:credit_card_expiration_notice)

    subject.perform
  end

  it "sends an email" do
    expect(mailer_service).to receive(:credit_card_expiring)

    subject.perform
  end

  it "allows only one attempt" do
    expect(subject.max_attempts).to eq(1)
  end
end