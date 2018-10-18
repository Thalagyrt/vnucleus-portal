require 'spec_helper'

describe Tickets::UpdateCreator do
  let(:ticket) { create :ticket }
  let(:user) { create :user }
  let(:incident_job) { double :incident_job }
  let(:incident_policy) { double :incident_policy, incident_job: incident_job }
  let(:params) { { body: 'test' } }

  subject { described_class.new(ticket: ticket, user: user, incident_policy: incident_policy) }

  describe "#update" do
    it "enqueues the incident job" do
      expect(Delayed::Job).to receive(:enqueue).with(incident_job)

      subject.create(params)
    end
  end
end