require 'spec_helper'

describe Solus::Server do
  let(:cluster) { create :solus_cluster }
  let(:server) { create :solus_server, cluster: cluster }

  describe ".find_pending_patches" do
    before { server.update_attributes state: :active, patch_period: 1, patch_period_unit: 'months' }

    context "when patch_at is nil" do
      context "when patch_out_of_band is true" do
        before { server.update_attributes patch_out_of_band: true }

        it "includes the server" do
          expect(Solus::Server.find_pending_patches).to include(server)
        end
      end

      context "when patch_out_of_band is false" do
        before { server.update_attributes patch_out_of_band: false }

        it "does not include the server" do
          expect(Solus::Server.find_pending_patches).to_not include(server)
        end
      end
    end

    context "when patch_at is in the future" do
      before { server.update_attributes patch_at: Time.zone.now + 5.days }

      context "when patch_out_of_band is true" do
        before { server.update_attributes patch_out_of_band: true }

        it "includes the server" do
          expect(Solus::Server.find_pending_patches).to include(server)
        end
      end

      context "when patch_out_of_band is false" do
        before { server.update_attributes patch_out_of_band: false }

        it "does not include the server" do
          expect(Solus::Server.find_pending_patches).to_not include(server)
        end
      end
    end

    context "when patch_at is in the past" do
      before { server.update_attributes patch_at: Time.zone.now - 5.days }

      context "when patch_out_of_band is true" do
        before { server.update_attributes patch_out_of_band: true }

        it "includes the server" do
          expect(Solus::Server.find_pending_patches).to include(server)
        end
      end

      context "when patch_out_of_band is false" do
        before { server.update_attributes patch_out_of_band: false }

        it "includes the server" do
          expect(Solus::Server.find_pending_patches).to include(server)
        end
      end
    end
  end

  describe "#hostname validation" do
    context "when the hostname is less than 4 characters" do
      it "is invalid" do
        server.hostname = "abc"

        expect(server).to_not be_valid
      end
    end

    context "when the hostname contains symbols" do
      it "is invalid" do
        server.hostname = "bet@force.com"

        expect(server).to_not be_valid
      end
    end

    context "when the hostname is a normal domain" do
      it "is valid" do
        server.hostname = "betaforce.com"

        expect(server).to be_valid
      end
    end

    context "when the hostname is a single word hostname" do
      it "is valid" do
        server.hostname = "betaforce"

        expect(server).to be_valid
      end
    end
  end

  describe "#provision_duration" do
    let(:base_time) { Time.zone.now }
    before { server.update_attributes provision_started_at: base_time - 1.minute, provision_completed_at: base_time }

    it "returns the provision duration" do
      expect(server.provision_duration).to eq(60)
    end
  end

  describe "#plan_string" do
    it "returns the concatenation of the template and plan plan parts" do
      expect(server.plan_string).to eq("#{server.template.plan_part}#{server.plan.plan_part}")
    end
  end

  describe "#template_string" do
    it "returns the template name" do
      expect(server.template_string).to eq("#{server.template.template}")
    end
  end

  describe "#to_s" do
    it "returns the server description" do
      expect(server.to_s).to eq("#{server.to_param} (#{server.hostname})")
    end
  end

  describe "#patched!" do
    before { server.update_attributes state: :active, patch_period: 1, patch_period_unit: 'months' }

    context "when patch_at is in the future" do
      before { server.update_attributes patch_at: Time.zone.now + 5.days }

      context "when patch_out_of_band is true" do
        before { server.update_attributes patch_out_of_band: true }

        it "sets patch_out_of_band to false" do
          expect { server.patched! }.to change { server.patch_out_of_band? }.to(false)
        end
      end
    end

    context "when patch_at is in the past" do
      before { server.update_attributes patch_at: Time.zone.now - 5.days }

      context "when patch_out_of_band is true" do
        before { server.update_attributes patch_out_of_band: true }

        it "sets patch_out_of_band to false" do
          expect { server.patched! }.to change { server.patch_out_of_band? }.to(false)
        end

        it "sets patch_at to the future" do
          expect { server.patched! }.to change { server.patch_at }.to(server.send(:new_patch_at))
        end
      end

      context "when patch_out_of_band is false" do
        before { server.update_attributes patch_out_of_band: false }

        it "sets patch_at to the future" do
          expect { server.patched! }.to change { server.patch_at }.to(server.send(:new_patch_at))
        end
      end
    end
  end
end