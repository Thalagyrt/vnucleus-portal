require 'spec_helper'

describe Tickets::ResolveIncidentJob do
  let(:pagerduty) { double(:pagerduty) }
  let(:ticket) { double(:ticket, incident_key: nil, pagerduty_api_key: nil) }
  subject { described_class.new(ticket: ticket, pagerduty: pagerduty) }

  before { allow(ticket).to receive(:with_lock) { |&b| b.call } }
  before { allow(ticket).to receive(:update_attributes) }

  context "when the ticket has an incident assigned" do
    let(:incident) { double(:incident, incident_key: 'dsfargeg') }

    before { allow(ticket).to receive(:incident_key).and_return(incident.incident_key) }
    before { allow(ticket).to receive(:pagerduty_api_key).and_return('abc123') }
    before { allow(pagerduty).to receive(:get_incident).with(ticket.incident_key).and_return(incident) }
    before { allow(incident).to receive(:resolve) }

    it "resolves the incident" do
      expect(incident).to receive(:resolve)

      subject.perform
    end
  end

  context "when the ticket doesn't have an incident assigned" do
    it "does not resolve an incident" do
      expect(pagerduty).to_not receive(:get_incident)

      subject.perform
    end
  end

  it "clears the ticket's incident key" do
    expect(ticket).to receive(:update_attributes).with hash_including(incident_key: nil)

    subject.perform
  end

  it "clears the ticket's pagerduty api key" do
    expect(ticket).to receive(:update_attributes).with hash_including(pagerduty_api_key: nil)

    subject.perform
  end

  it "clears the ticket's trigger schedule" do
    expect(ticket).to receive(:update_attributes).with hash_including(trigger_incident_at: nil)

    subject.perform
  end
end