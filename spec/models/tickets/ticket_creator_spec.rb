require 'spec_helper'

describe Tickets::TicketCreator do
  let(:account) { create :account }
  let(:user) { create :user }
  let(:incident_job) { double :incident_job }
  let(:incident_policy) { double :incident_policy, incident_job: incident_job }
  let(:incident_policy_class) { double(:incident_policy_class) }
  let(:params) { { subject: 'test', body: 'test' } }

  before { allow(incident_policy_class).to receive(:new).and_return(incident_policy) }

  subject { described_class.new(account: account, user: user, incident_policy_class: incident_policy_class) }

  describe "#create" do
    it "enqueues the incident job" do
      expect(Delayed::Job).to receive(:enqueue).with(incident_job)

      subject.create(params)
    end
  end
end