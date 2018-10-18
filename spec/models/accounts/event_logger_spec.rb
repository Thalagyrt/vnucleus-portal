require 'spec_helper'

describe Accounts::EventLogger do
  let(:user) { create :user_with_account }
  let(:account) { user.accounts.first }
  subject { described_class.new(account: account) }

  describe "#log" do
    it "saves an event on the account" do
      expect { subject.log("test message") }.to change { account.events.count }.by(1)
    end
  end

  describe "#with_user" do
    it "returns a new instance of the logger" do
      expect(subject.with_user(user)).to be_instance_of(Accounts::EventLogger)

      expect(subject.with_user(user)).to_not be(subject)
    end

    it "assigns the user" do
      expect(subject.with_user(user).instance_variable_get(:@user)).to be(user)
    end
  end

  describe "#with_entity" do
    let(:server) { create :solus_server, account: account }

    it "returns a new instance of the logger" do
      expect(subject.with_entity(server)).to be_instance_of(Accounts::EventLogger)

      expect(subject.with_entity(server)).to_not be(subject)
    end

    it "assigns the entity" do
      expect(subject.with_entity(server).instance_variable_get(:@entity)).to be(server)
    end
  end

  describe "#with_ip_address" do
    let(:ip_address) { "10.0.80.2" }

    it "returns a new instance of the logger" do
      expect(subject.with_ip_address(ip_address)).to be_instance_of(Accounts::EventLogger)

      expect(subject.with_ip_address(ip_address)).to_not be(subject)
    end

    it "assigns the IP address" do
      expect(subject.with_ip_address(ip_address).instance_variable_get(:@ip_address)).to eq(ip_address)
    end
  end

  describe "#with_category" do
    let(:category) { :security }

    it "returns a new instance of the logger" do
      expect(subject.with_category(category)).to be_instance_of(Accounts::EventLogger)

      expect(subject.with_category(category)).to_not be(subject)
    end

    it "assigns the category" do
      expect(subject.with_category(category).instance_variable_get(:@category)).to eq(category)
    end
  end
end