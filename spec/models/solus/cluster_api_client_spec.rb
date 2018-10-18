require 'spec_helper'

describe Solus::ApiClientService do
  let(:cluster) { create :solus_cluster }
  subject { described_class.new(cluster: cluster) }

  describe "#api_command" do
    context "when SolusVM returns an error" do
      before do
        stub_request(:get, "https://10.0.0.1:5656/api/admin/command.php?action=listnodes&id=id&key=secret&rdtype=json&type=xen").
            to_return(:status => 401, :body => '')
      end

      it "returns false" do
        expect(subject.api_command('listnodes', type: 'xen')).to be_falsey
      end
    end

    context "when SolusVM returns successfully" do
      before do
        stub_request(:get, "https://10.0.0.1:5656/api/admin/command.php?action=listnodes&id=id&key=secret&rdtype=json&type=xen").
            to_return(:status => 200, :body => '{"status": "success", "nodes": "Xen1,Xen2"}')
      end

      context "and no block was given" do
        it "returns true" do
          expect(subject.api_command('listnodes', type: 'xen')).to be_truthy
        end
      end

      context "and a block was given" do
        it "calls the block" do
          expect { |b| subject.api_command('listnodes', type: 'xen', &b) }.to yield_control
        end
      end
    end
  end
end