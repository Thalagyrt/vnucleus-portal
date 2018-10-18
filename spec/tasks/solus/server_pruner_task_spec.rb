require 'spec_helper'

describe Solus::ServerPrunerTask do
  subject { described_class.new }

  let(:old_server) { create :solus_server, state: :pending_confirmation }
  before { old_server.update_attribute(:created_at, 3.days.ago)}

  let!(:fresh_server) { create :solus_server, state: :pending_confirmation }

  let(:active_server) { create :solus_server, state: :active }
  before { active_server.update_attribute(:created_at, 3.weeks.ago)}

  it "cancels pending servers older than 3 days" do
    expect { subject.perform }.to change { old_server.reload.state }.to('order_cancelled')
  end
end