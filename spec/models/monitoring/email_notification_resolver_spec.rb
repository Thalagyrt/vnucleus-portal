require 'spec_helper'

describe Monitoring::EmailNotificationResolver do
  let(:check) { double(:check) }
  let(:notification) { double(:notificaiton, check: check, target_value: "jriley@vnucleus.com") }
  let(:mailer) { double(:mailer) }
  let(:mail) { double(:mail) }

  subject { described_class.new(notification: notification, mailer: mailer) }

  before { allow(mailer).to receive(:check_status).with(check: check, email: notification.target_value).and_return(mail) }
  before { allow(mailer).to receive(:delay).and_return(mailer) }
  before { allow(mail).to receive(:deliver) }

  it "sends appropriate data to the mailer" do
    expect(mailer).to receive(:check_status).with(check: check, email: notification.target_value)

    subject.resolve
  end
end