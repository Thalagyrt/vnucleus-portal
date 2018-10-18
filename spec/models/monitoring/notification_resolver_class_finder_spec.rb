require 'spec_helper'

describe Monitoring::NotificationResolverClassFinder do
  subject { described_class.new }

  context "with an email notification" do
    let(:notification) { double(:notification, target_type: :email) }

    it "returns Monitoring::EmailNotificationResolver" do
      expect(subject.for_notification(notification)).to be Monitoring::EmailNotificationResolver
    end
  end

  context "with a pagerduty notification" do
    let(:notification) { double(:notification, target_type: :pagerduty) }

    it "returns Monitoring::PagerdutyNotificationResolver" do
      expect(subject.for_notification(notification)).to be Monitoring::PagerdutyNotificationResolver
    end
  end
end