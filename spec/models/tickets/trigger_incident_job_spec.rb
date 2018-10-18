require 'spec_helper'

describe Tickets::TriggerIncidentJob do
  let(:pagerduty) { double(:pagerduty) }
  let(:ticket) { double(:ticket, incident_key: nil, trigger_incident_at: Time.zone.now, priority: :high) }
  subject { described_class.new(ticket: ticket, pagerduty: pagerduty) }

  before { allow(ticket).to receive(:with_lock) { |&b| b.call } }

  context "when the ticket doesn't have an incident assigned" do
    let(:incident) { double(:incident, incident_key: 'dsfargeg') }
    before { allow(pagerduty).to receive(:trigger).and_return(incident) }
    before { allow(ticket).to receive(:update_attributes) }

    it "triggers an incident" do
      expect(pagerduty).to receive(:trigger)

      subject.perform
    end

    it "sets the ticket's incident key" do
      expect(ticket).to receive(:update_attributes).with hash_including(incident_key: incident.incident_key)

      subject.perform
    end
  end

  context "when the ticket doesn't have an incident scheduled" do
    before { allow(ticket).to receive(:trigger_incident_at).and_return(nil) }

    it "does not trigger an incident" do
      expect(pagerduty).to_not receive(:trigger)

      subject.perform
    end
  end

  context "when the ticket has an incident assigned" do
    before { allow(ticket).to receive(:incident_key).and_return('dsfargeg') }

    it "does not trigger an incident" do
      expect(pagerduty).to_not receive(:trigger)

      subject.perform
    end
  end
end