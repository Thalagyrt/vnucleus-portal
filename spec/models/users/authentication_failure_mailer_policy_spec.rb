require 'spec_helper'

describe Users::AuthenticationFailureMailerPolicy do
  subject { described_class.new(user: user) }

  context "with a regular user" do
    let(:user) { double :user, is_staff?: false }

    it "returns the user mailer service" do
      expect(subject.mailer).to be_instance_of(Users::MailerService)
    end
  end

  context "with a staff user" do
    let(:user) { double :user, is_staff?: true }

    it "returns the admin mailer service" do
      expect(subject.mailer).to be_instance_of(Admin::MailerService)
    end
  end
end