require 'spec_helper'

describe Accounts::CreditCardRemovalJob do
  let(:account) { double(:account) }
  let(:stripe_card_service) { double(:stripe_card_service) }
  let(:event_logger) { double(:event_logger) }
  let(:mailer_service) { double(:mailer_service) }

  subject { described_class.new(account: account, stripe_card_service: stripe_card_service, event_logger: event_logger, mailer_service: mailer_service) }

  before { allow(event_logger).to receive(:log) }
  before { allow(stripe_card_service).to receive(:delete) }
  before { allow(mailer_service).to receive(:credit_card_removed) }

  it "adds an event log entry" do
    expect(event_logger).to receive(:log).with(:credit_card_removed)

    subject.perform
  end

  it "notifies the user" do
    expect(mailer_service).to receive(:credit_card_removed)

    subject.perform
  end

  it "deletes the cards" do
    expect(stripe_card_service).to receive(:delete)

    subject.perform
  end
end