require 'spec_helper'

describe Monitoring::CheckRunnerJob do
  let(:server) { double(:server) }
  let(:check) { double(:check, active?: true, server: server, should_notify?: false, should_resolve_low?: false, should_resolve_high?: false, status_message: '200', next_run_at: Time.zone.now - 30.seconds) }
  let(:notification_sender) { double(:notification_sender) }
  let(:notification_resolver) { double(:notification_resolver) }
  let(:check_http) { double(:check_http) }
  let(:check_class) { double(:check_class) }
  let(:check_class_finder) { double(:check_class_finder, check_class: check_class)}

  before { allow(check).to receive(:with_lock).and_yield }
  before { allow(check_http).to receive(:perform) }
  before { allow(check_class).to receive(:new).and_return(check_http) }
  before { allow(notification_sender).to receive(:send_notification) }
  before { allow(notification_resolver).to receive(:resolve) }

  subject do
    described_class.new(
        check: check,
        notification_sender: notification_sender,
        notification_resolver: notification_resolver,
        check_class_finder: check_class_finder,
    )
  end

  it "performs the check_http" do
    expect(check_http).to receive(:perform)

    subject.perform
  end

  context "when next_run_at is in the future" do
    before { allow(check).to receive(:next_run_at).and_return(Time.zone.now + 5.minutes) }

    it "does not perform the check_http" do
      expect(check_http).to_not receive(:perform)

      subject.perform
    end
  end

  context "when the check is not active" do
    before { allow(check).to receive(:active?).and_return(false) }

    it "does not perform the check_http" do
      expect(check_http).to_not receive(:perform)

      subject.perform
    end
  end

  context "when the check should notify" do
    before { allow(check).to receive(:should_notify?).and_return(true) }

    it "sends the notification" do
      expect(notification_sender).to receive(:send_notification)

      subject.perform
    end
  end

  context "when the check should resolve low" do
    before { allow(check).to receive(:should_resolve_low?).and_return(true) }

    it "resolves the notifications" do
      expect(notification_resolver).to receive(:resolve).with(:low)

      subject.perform
    end
  end

  context "when the check should resolve high" do
    before { allow(check).to receive(:should_resolve_high?).and_return(true) }

    it "resolves the notifications" do
      expect(notification_resolver).to receive(:resolve).with(:high)

      subject.perform
    end
  end
end