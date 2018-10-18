module Accounts
  class InviteDecorator < ApplicationDecorator
    include ::Concerns::TimestampDecoratorConcern

    delegate_all

    def render_roles
      object.roles.map { |r| r.to_s.titleize }.join(', ')
    end
  end
end