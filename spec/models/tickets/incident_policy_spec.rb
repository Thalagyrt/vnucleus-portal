require 'spec_helper'

describe Tickets::IncidentPolicy do
  let(:ticket) { double(:ticket, pagerduty_api_key: 'test_123') }
  subject { described_class.new(ticket: ticket, user: user) }

  context "with a regular user" do
    context "when the ticket is open" do
      let(:user) { double(:user, is_staff?: false) }
      before { allow(ticket).to receive(:open?).and_return(true) }

      it "returns a TriggerIncidentJob" do
        expect(subject.incident_job).to be_instance_of(Tickets::ScheduleIncidentJob)
      end
    end

    context "when the ticket is closed" do
      let(:user) { double(:user, is_staff?: false) }
      before { allow(ticket).to receive(:open?).and_return(false) }

      it "returns a ResolveIncidentJob" do
        expect(subject.incident_job).to be_instance_of(Tickets::ResolveIncidentJob)
      end
    end
  end

  context "with a staff user" do
    let(:user) { double(:user, is_staff?: true) }

    it "returns a ResolveIncidentJob" do
      expect(subject.incident_job).to be_instance_of(Tickets::ResolveIncidentJob)
    end
  end
end