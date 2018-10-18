class PagesController < ApplicationController
  decorates_assigned :managed_plans, :self_managed_plans, :featured_plans, :templates, :coupon

  def index
    @sign_up_form = ::Users::SignUpForm.new(affiliate_id: cookies[:affiliate_id])
  end

  def pricing
    @sign_up_form = ::Users::SignUpForm.new(affiliate_id: cookies[:affiliate_id])
    @featured_plans = Solus::Plan.featured
    @coupon = Orders::Coupon.find_active.find_published.sorted.first
    @managed_plans = Solus::Plan.active.where(managed: true).sorted
    @self_managed_plans = Solus::Plan.active.where.not(managed: true).sorted
  end
end