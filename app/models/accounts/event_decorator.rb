module Accounts
  class EventDecorator < ApplicationDecorator
    include ::Concerns::TimestampDecoratorConcern

    decorates_association :account
    decorates_association :user
    decorates_association :entity

    delegate_all

    def render_category
      if object.category.present?
        I18n.t("account.event.category.#{object.category}")
      else
        "None"
      end
    end

    def render_message
      I18n.t("account.event.message.#{object.message}")
    end

    def render_user_name
      if user
        user.render_full_name
      else
        h.content_tag :span, data: { raw: 'System' } do
          "System"
        end
      end
    end

    def link_user_name(*scope)
      if user
        user.link_full_name(*scope)
      else
        h.content_tag :span, data: { raw: 'System' } do
          "System"
        end
      end
    end

    def link_entity(*scope)
      h.content_tag :span, data: { raw: entity_name } do
        if policy_finder.linkable?
          h.link_to entity_name, [*scope, account, *policy_finder.route]
        else
          entity_name
        end
      end
    end

    def render_ip_address
      if object.ip_address
        object.ip_address
      else
        "N/A"
      end
    end

    private
    def entity_name
      if entity
        entity.to_s
      else
        "N/A"
      end
    end

    def policy_finder
      EventLinkPolicy::Finder.new(event: object)
    end
  end
end