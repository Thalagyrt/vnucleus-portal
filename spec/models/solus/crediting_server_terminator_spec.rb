require 'spec_helper'

class ServerTerminatorMock
  include Wisper::Publisher

  def initialize(publish)
    @publish = publish
  end

  def terminate(_)
    publish(@publish)
  end
end

describe Solus::CreditingServerTerminator do
  let(:account) { double(:account) }
  let(:server) { double(:server, prorated_amount: 150, next_due: Time.zone.today, account: account) }
  let(:credit_service) { double(:credit_service) }
  let(:event_logger) { double(:event_logger) }
  let(:server_terminator) { ServerTerminatorMock.new(:terminate_success) }

  subject { described_class.new(server: server, credit_service: credit_service, server_terminator: server_terminator, event_logger: event_logger) }

  describe "#terminate" do
    it "applies a credit in the amount of the server's prorated amount" do
      expect(credit_service).to receive(:add_credit).with(server.prorated_amount, anything)

      subject.terminate({})
    end

    it "requests termination of the server" do
      params = double(:params)

      expect(server_terminator).to receive(:terminate).with(params)

      subject.terminate(params)
    end
  end
end