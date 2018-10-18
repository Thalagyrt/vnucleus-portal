require 'spec_helper'

describe Users::EventLogger do
  let(:user) { create :user }
  subject { described_class.new(user: user) }

  describe "#log" do
    it "saves an event on the user" do
      expect { subject.log("test message") }.to change { user.events.count }.by(1)
    end
  end

  describe "#with_ip_address" do
    let(:ip_address) { "10.0.80.2" }

    it "returns a new instance of the logger" do
      expect(subject.with_ip_address(ip_address)).to be_instance_of(Users::EventLogger)

      expect(subject.with_ip_address(ip_address)).to_not be(subject)
    end

    it "assigns the IP address" do
      expect(subject.with_ip_address(ip_address).instance_variable_get(:@ip_address)).to eq(ip_address)
    end
  end

  describe "#with_category" do
    let(:category) { :security }

    it "returns a new instance of the logger" do
      expect(subject.with_category(category)).to be_instance_of(Users::EventLogger)

      expect(subject.with_category(category)).to_not be(subject)
    end

    it "assigns the category" do
      expect(subject.with_category(category).instance_variable_get(:@category)).to eq(category)
    end
  end
end