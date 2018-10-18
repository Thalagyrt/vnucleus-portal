require 'spec_helper'

describe Solus::ConsolePolicy do
  subject { described_class.new(server: server) }

  describe "#type" do
    context "with a xen server" do
      let(:server) { double(:server, virtualization_type: 'xen') }

      it "returns :ssh" do
        expect(subject.type).to eq(:ssh)
      end
    end

    context "with a xen hvm server" do
      let(:server) { double(:server, virtualization_type: 'xen hvm') }

      it "returns :vnc" do
        expect(subject.type).to eq(:vnc)
      end
    end

    context "with an invalid server" do
      let(:server) { double(:server, virtualization_type: nil) }

      it "raises an argument error" do
        expect { subject.type }.to raise_error(ArgumentError)
      end
    end
  end
end