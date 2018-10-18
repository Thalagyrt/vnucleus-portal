require 'spec_helper'

describe Solus::ServerCreator do
  let(:user) { create :user_with_account }
  let(:account) { user.accounts.first }
  let(:coupon) { double(:coupon, coupon_code: '') }

  let!(:cluster) { create :solus_cluster }
  let!(:node) { create :solus_node, cluster: cluster }
  let!(:plan) { create :solus_plan }
  let!(:template) { create :solus_template }

  before { cluster.plans << plan }
  before { plan.templates << template }

  let(:server) { account.solus_servers.first }
  let(:current_power) { Power.new(user) }
  let(:server_form_params) do
    {
        hostname: 'testbox',
        plan_id: plan.id,
        template_id: template.id,
        cluster_id: cluster.id,
        coupon_code: coupon.coupon_code,
        current_power: current_power
    }
  end

  subject { described_class.new(account: account) }

  context "when a coupon is applied" do
    let!(:coupon) { create :coupon, factor: 0.8 }

    it "applies the discounted server price" do
      subject.create(server_form_params)

      expect(server.amount).to eq(plan.amount * coupon.factor)
    end
  end
end