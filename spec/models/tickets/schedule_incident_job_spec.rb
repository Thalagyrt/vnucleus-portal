require 'spec_helper'

describe Tickets::ScheduleIncidentJob do
  let(:ticket) { double(:ticket, incident_key: nil, trigger_incident_at: nil, priority: 'normal') }
  subject { described_class.new(ticket: ticket) }
  
  before { allow(ticket).to receive(:with_lock) { |&b| b.call } }

  context "with a priority of normal" do
    before { allow(ticket).to receive(:priority).and_return('normal') }

    it "sets the incident time to 4 hours from now" do
      expect(ticket).to receive(:update_attributes).with hash_including(trigger_incident_at: Time.zone.now + 1.hour)

      subject.perform
    end
  end

  context "with a priority of normal" do
    before { allow(ticket).to receive(:priority).and_return('critical') }

    it "sets the incident time to 5 minutes from now" do
      expect(ticket).to receive(:update_attributes).with hash_including(trigger_incident_at: Time.zone.now + 5.minutes)

      subject.perform
    end
  end

  context "when the ticket has an incident assigned" do
    before { allow(ticket).to receive(:incident_key).and_return('dsfargeg') }

    it "does not schedule an incident" do
      expect(ticket).to_not receive(:update_attributes).with hash_including(trigger_incident_at: anything)

      subject.perform
    end
  end

  context "when the ticket has an incident scheduled" do
    context "and the incident is earlier than the new scheduled time" do
      before { allow(ticket).to receive(:trigger_incident_at).and_return(Time.zone.now) }

      it "does not change the incident" do
        expect(ticket).to_not receive(:update_attributes).with hash_including(trigger_incident_at: anything)

        subject.perform
      end
    end

    context "and the incident is later than the new scheduled time" do
      before { allow(ticket).to receive(:trigger_incident_at).and_return(Time.zone.now + 7.days) }

      it "updates the incident time" do
        expect(ticket).to receive(:update_attributes).with hash_including(trigger_incident_at: anything)

        subject.perform
      end
    end
  end
end