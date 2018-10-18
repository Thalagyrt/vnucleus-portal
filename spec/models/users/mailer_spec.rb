require 'spec_helper'

describe Users::Mailer do
  let(:user) { create :user }

  describe 'login_failed' do
    let(:mail) { described_class.login_failed(user: user, ip_address: '127.0.0.1') }

    it "renders the subject" do
      expect(mail.subject).to eq("Failed login from 127.0.0.1")
    end

    it "has the correct sender email" do
      expect(mail.from).to eq(['noreply@vnucleus.com'])
    end

    it "has the correct recipient" do
      expect(mail.to).to eq([user.email])
    end

    it "greets the user by name" do
      expect(mail.body.encoded).to match(user.first_name)
    end

    it "contains the IP address" do
      expect(mail.body.encoded).to match("127.0.0.1")
    end
  end
end
