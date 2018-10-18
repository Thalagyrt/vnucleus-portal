module Accounts
  class MembershipDecorator < ApplicationDecorator
    delegate_all

    decorates_association :account
    decorates_association :user

    def render_roles
      object.roles.map { |r| r.to_s.titleize }.join(', ')
    end

    def render_user_name
      user.render_full_name
    end

    def link_user_name(*scope)
      user.link_full_name(*scope)
    end
  end
end