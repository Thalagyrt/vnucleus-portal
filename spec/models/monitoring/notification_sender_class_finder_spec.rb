require 'spec_helper'

describe Monitoring::NotificationSenderClassFinder do
  subject { described_class.new }

  context "with an email target" do
    let(:target) { double(:target, target_type: :email) }

    it "returns EmailNotificationSenderJob" do
      expect(subject.for_target(target)).to be Monitoring::EmailNotificationSender
    end
  end

  context "with a pagerduty target" do
    let(:target) { double(:target, target_type: :pagerduty) }

    it "returns PagerdutyNotificationSenderJob" do
      expect(subject.for_target(target)).to be Monitoring::PagerdutyNotificationSender
    end
  end
end