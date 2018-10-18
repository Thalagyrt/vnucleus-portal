require 'spec_helper'

describe Accounts::Membership do
  describe 'roles' do
    let(:membership) { Accounts::Membership.new }

    it "has a value of 1 for full_control" do
      membership.roles << :full_control
      expect(membership.roles_mask).to eq(1)
    end

    it "has a value of 2 for manage_billing" do
      membership.roles << :manage_billing
      expect(membership.roles_mask).to eq(2)
    end

    it "has a value of 4 for manage_servers" do
      membership.roles << :manage_servers
      expect(membership.roles_mask).to eq(4)
    end

    it "has 4 roles total" do
      expect(Accounts::Membership.valid_roles.count).to eq(3)
    end
  end
end