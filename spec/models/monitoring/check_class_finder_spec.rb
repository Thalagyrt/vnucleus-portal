require 'spec_helper'

describe Monitoring::CheckClassFinder do
  subject { described_class.new(check: check) }

  context "with an ICMP check" do
    let(:check) { create :icmp_check }

    it "returns CheckICMP" do
      expect(subject.check_class).to be(Monitoring::CheckICMP)
    end
  end

  context "with an HTTP check" do
    let(:check) { create :http_check }

    it "returns CheckHTTP" do
      expect(subject.check_class).to be(Monitoring::CheckHTTP)
    end
  end

  context "with a TCP check" do
    let(:check) { create :tcp_check }

    it "returns CheckTCP" do
      expect(subject.check_class).to be(Monitoring::CheckTCP)
    end
  end

  context "with an NRPE check" do
    let(:check) { create :nrpe_check }

    it "returns CheckNRPE" do
      expect(subject.check_class).to be(Monitoring::CheckNRPE)
    end
  end

  context "with an SSL Validity check" do
    let(:check) { create :ssl_validity_check }

    it "returns CheckSSLValidity" do
      expect(subject.check_class).to be(Monitoring::CheckSSLValidity)
    end
  end
end