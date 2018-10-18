require 'spec_helper'

describe Orders::Coupon do
  subject { described_class.new(coupon_code: 'test', factor: 0.8, status: :active) }

  let(:server) { create :solus_server, plan_amount: 1000 }

  describe "#apply" do
    it "applies the discount" do
      expect { subject.apply(server) }.to change { server.plan_amount }.to(800)
    end
  end

  describe "#coupon_code=" do
    it "downcases the coupon code" do
      expect { subject.coupon_code = "GOONVPS" }.to change { subject.coupon_code }.to('goonvps')
    end
  end

  describe ".fetch" do
    context "with a valid coupon code" do
      before { subject.save! }

      context "when expires_at is null" do
        before { subject.update_attributes expires_at: nil }

        it "returns a coupon code" do
          expect(described_class.fetch(subject.coupon_code)).to eq(subject)
        end
      end

      context "when expires_at is in the future" do
        before { subject.update_attributes expires_at: Time.zone.now + 1.week }

        it "returns a coupon code" do
          expect(described_class.fetch(subject.coupon_code)).to eq(subject)
        end
      end

      context "when expires_at is in the past" do
        before { subject.update_attributes expires_at: Time.zone.now - 1.second }

        it "returns a NullCoupon" do
          expect(described_class.fetch(subject.coupon_code)).to be_instance_of(Orders::NullCoupon)
        end
      end

      context "when begins_at is null" do
        before { subject.update_attributes begins_at: nil }

        it "returns a coupon code" do
          expect(described_class.fetch(subject.coupon_code)).to eq(subject)
        end
      end

      context "when begins_at is in the future" do
        before { subject.update_attributes begins_at: Time.zone.now + 1.week }

        it "returns a NullCoupon" do
          expect(described_class.fetch(subject.coupon_code)).to be_instance_of(Orders::NullCoupon)
        end
      end

      context "when expires_at is in the past" do
        before { subject.update_attributes begins_at: Time.zone.now - 1.second }

        it "returns a coupon code" do
          expect(described_class.fetch(subject.coupon_code)).to eq(subject)
        end
      end
    end

    context "with an invalid coupon code" do
      it "returns a NullCoupon" do
        expect(described_class.fetch('asdf')).to be_instance_of(Orders::NullCoupon)
      end
    end
  end
end