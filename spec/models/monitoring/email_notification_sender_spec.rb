require 'spec_helper'

describe Monitoring::EmailNotificationSender do
  let(:email) { "jriley@vnucleus.com" }
  let(:check) { create :icmp_check }
  let(:mailer) { double(:mailer) }
  let(:mail) { double(:mail) }

  subject { described_class.new(check: check, target_value: email, mailer: mailer) }
  before { allow(mailer).to receive(:check_status).with(anything).and_return(mail) }
  before { allow(mailer).to receive(:delay).and_return(mailer) }
  before { allow(mail).to receive(:deliver) }

  it "sends an email with the correct target address and check" do
    expect(mailer).to receive(:check_status).with(check: check, email: email)

    subject.send_notification
  end

  it "creates a notification object" do
    expect { subject.send_notification }.to change { Monitoring::Notification.current_for_target(:email, email).present? }.to true
  end

  context "when a notification already exists" do
    let!(:notification) { check.notifications.create!(target_type: :email, target_value: email, current_priority: :low) }

    context "and the check's priority matches the notification" do
      before { check.update_attributes status_code: :warning }

      it "does not send an email" do
        expect(mailer).to_not receive(:check_status)

        subject.send_notification
      end
    end

    context "and the check's priority does not match the notification" do
      before { check.update_attributes status_code: :critical }

      it "sends an email" do
        expect(mailer).to receive(:check_status)

        subject.send_notification
      end

      it "updates the notification" do
        expect { subject.send_notification }.to change { notification.reload.current_priority.to_sym }.to :high
      end
    end
  end
end