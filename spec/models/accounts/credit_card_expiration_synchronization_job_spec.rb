require 'spec_helper'

describe Accounts::CreditCardExpirationSynchronizationJob do
  let(:account) { double(:account) }
  let(:mailer_service) { double(:mailer_service) }
  let(:event_logger) { double(:event_logger) }
  let(:stripe_card_service) { double(:stripe_card_service) }
  let(:card) { double(expiration_year: new_expiration_date.year, expiration_month: new_expiration_date.month) }

  subject { described_class.new(account: account, mailer_service: mailer_service, event_logger: event_logger, stripe_card_service: stripe_card_service) }

  before { allow(event_logger).to receive(:log) }
  before { allow(account).to receive(:update_attributes) }
  before { allow(mailer_service).to receive(:credit_card_expiring) }
  before { allow(stripe_card_service).to receive(:fetch).and_return(card) }

  context "when the card service returns a credit card with a new expiration date" do
    let(:new_expiration_date) { Time.zone.today.at_beginning_of_month + 1.year }

    before { allow(mailer_service).to receive(:new_credit_card_found) }

    it "updates the account's expiration date" do
      expect(account).to receive(:update_attributes).with(stripe_expiration_date: new_expiration_date)

      subject.perform
    end

    it "emails the users" do
      expect(mailer_service).to receive(:new_credit_card_found)

      subject.perform
    end

    it "logs the event" do
      expect(event_logger).to receive(:log).with(:new_credit_card_found)

      subject.perform
    end
  end

  context "when the card service returns the same credit card" do
    let(:new_expiration_date) { Time.zone.today.at_beginning_of_month - 1.year }

    before { allow(stripe_card_service).to receive(:delete) }
    before { allow(mailer_service).to receive(:credit_card_removed) }

    it "emails the users" do
      expect(mailer_service).to receive(:credit_card_removed)

      subject.perform
    end

    it "logs the event" do
      expect(event_logger).to receive(:log).with(:credit_card_removed)

      subject.perform
    end

    it "deletes the card" do
      expect(stripe_card_service).to receive(:delete)

      subject.perform
    end
  end
end