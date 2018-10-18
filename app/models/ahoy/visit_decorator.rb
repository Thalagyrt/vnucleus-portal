module Ahoy
  class VisitDecorator < ApplicationDecorator
    include ::Concerns::TimestampDecoratorConcern

    delegate_all

    decorates_association :user
    decorates_association :events

    def link_id(*scope)
      h.content_tag :span, data: { raw: id } do
        h.link_to id.to_s, [*scope, object]
      end
    end

    def render_user
      if user.present?
        user.link_full_name :admin
      else
        "N/A"
      end
    end

    def render_utm_medium
      utm_medium || "N/A"
    end

    def render_utm_campaign
      utm_campaign || "N/A"
    end

    def render_utm_source
      utm_source || "N/A"
    end

    def render_utm_data
      "#{utm_medium}/#{utm_source}/#{utm_campaign}"
    end
  end
end