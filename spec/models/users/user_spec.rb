require 'spec_helper'

describe Users::User do
  describe "validation" do
    it "requires an email address" do
      expect(build(:user, email: '')).to_not be_valid
    end

    it "requires an email address containing only one @" do
      expect(build(:user, email: 'asdf@asdf@com')).to_not be_valid
    end

    it "rejects emails containing SMTP injection" do
      expect(build(:user, email: "rcpt=to@example.jp>\r\nDATA\r\n(message content)\r\n.\r\nQUIT\r\n")).to_not be_valid
    end

    it "requires a unique email address" do
      user = create(:user)

      expect(build(:user, email: user.email)).to_not be_valid
    end

    it "requires a first name" do
      expect(build(:user, first_name: '')).to_not be_valid
    end

    it "requires a last name" do
      expect(build(:user, last_name: '')).to_not be_valid
    end

    it "requires a phone number" do
      expect(build(:user, phone: '')).to_not be_valid
    end
  end

  describe "#email=" do
    let(:user) { build :user }

    it "downcases the email" do
      user.email = 'JRILEY@BETAFORCE.COM'

      expect(user.email).to eq('jriley@betaforce.com')
    end
  end

  describe "#authenticate" do
    let(:user) { create :user }

    it "returns true if the password matches" do
      expect(user.authenticate(user.password)).to be_truthy
    end

    it "returns false if the password does not match" do
      expect(user.authenticate("#{user.password}olol")).to be_falsey
    end

    context "when the user is banned" do
      before { user.update_attributes state: :banned }

      it "returns false" do
        expect(user.authenticate(user.password)).to be_falsey
      end
    end
  end
end