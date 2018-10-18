require 'spec_helper'

describe Monitoring::Check do
  let(:check) { create :icmp_check }
  let(:server) { check.server }

  describe ".search" do
    let(:other_check) { create :icmp_check }

    it "includes checks that match" do
      expect(described_class.search(server.hostname)).to include(check)
    end

    it "does not include checks that don't match" do
      expect(described_class.search(server.hostname)).to_not include(other_check)
    end
  end

  describe ".find_runnable" do
    context "when next_run_at is in the past" do
      before { check.update_attributes next_run_at: Time.zone.now - 5.minutes }

      it "is not included in find_runnable" do
        expect(described_class.find_runnable).to include(check)
      end
    end

    context "when next_run_at is in the future" do
      before { check.update_attributes next_run_at: Time.zone.now + 5.minutes }

      it "is not included in find_runnable" do
        expect(described_class.find_runnable).to_not include(check)
      end
    end
  end

  describe "#should_notify?" do
    context "when verified is true" do
      before { check.update_attributes verified: true }

      context "when the failure count is less than the notification threshold" do
        before { check.update_attributes failure_count: check.notify_after_failures - 1 }

        it "should be false" do
          expect(check.should_notify?).to be_falsey
        end
      end

      context "when the failure count is greater than or equal to the notification threshold" do
        before { check.update_attributes failure_count: check.notify_after_failures }

        it "should be true" do
          expect(check.should_notify?).to be_truthy
        end

        context "when muzzle_until is in the future" do
          before { check.update_attributes muzzle_until: Time.zone.now + 5.minutes }

          it "should be false" do
            expect(check.should_notify?).to be_falsey
          end
        end

        context "when muzzle_until is in the past" do
          before { check.update_attributes muzzle_until: Time.zone.now - 1.second }

          it "should be true" do
            expect(check.should_notify?).to be_truthy
          end
        end
      end
    end

    context "when verified is false" do
      before { check.update_attributes verified: false }

      context "when the failure count is less than the notification threshold" do
        before { check.update_attributes failure_count: check.notify_after_failures - 1 }

        it "should be false" do
          expect(check.should_notify?).to be_falsey
        end
      end

      context "when the failure count is greater than or equal to the notification threshold" do
        before { check.update_attributes failure_count: check.notify_after_failures }

        it "should be true" do
          expect(check.should_notify?).to be_falsey
        end
      end
    end
  end

  describe "#should_resolve_low?" do
    context "when the failure count is greater than zero" do
      before { check.update_attributes failure_count: 1 }

      it "should be false" do
        expect(check.should_resolve_low?).to be_falsey
      end
    end

    context "when the failure count is zero" do
      before { check.update_attributes failure_count: 0 }

      it "should be true" do
        expect(check.should_resolve_low?).to be_truthy
      end
    end
  end

  describe "#should_resolve_high?" do
    context "when the current priority is high" do
      before { check.update_attributes status_code: :critical }

      it "should be false" do
        expect(check.should_resolve_high?).to be_falsey
      end
    end

    context "when the current priority is low" do
      before { check.update_attributes status_code: :warning }

      it "should be true" do
        expect(check.should_resolve_high?).to be_truthy
      end
    end
  end

  context "ICMP Test" do
    let(:check) { create :icmp_check }

    it "is valid" do
      expect(check).to be_valid
    end

    context "with data in the URI field" do
      it "is not valid" do
        check.check_data = "22"

        expect(check).to_not be_valid
      end
    end
  end

  context "HTTP Test" do
    let(:check) { create :http_check }

    it "is valid" do
      expect(check).to be_valid
    end

    context "with a port in the URI field" do
      it "is not valid" do
        check.check_data = "22"

        expect(check).to_not be_valid
      end
    end

    context "with nothing in the URI field" do
      it "is not valid" do
        check.check_data = nil

        expect(check).to_not be_valid
      end
    end
  end

  context "TCP Test" do
    let(:check) { create :tcp_check }

    it "is valid" do
      expect(check).to be_valid
    end

    context "with a URI in the URI field" do
      it "is not valid" do
        check.check_data = "http://localhost"

        expect(check).to_not be_valid
      end
    end

    context "with nothing in the URI field" do
      it "is not valid" do
        check.check_data = nil

        expect(check).to_not be_valid
      end
    end
  end
end