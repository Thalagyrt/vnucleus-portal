module Users
  class EnhancedSecurityTokenDecorator < ApplicationDecorator
    include ::Concerns::TimestampDecoratorConcern

    delegate_all

    def render_authorized
      if authorized?
        h.content_tag :i, class: 'fa text-success fa-check' do
          ""
        end
      else
        h.content_tag :i, class: 'fa text-danger fa-times' do
          ""
        end
      end
    end

    def render_last_seen_at
      h.content_tag :span, class: 'time zone unprocessed', data: { utc: last_seen_at.to_i, raw: last_seen_at.to_i } do
        object.last_seen_at.try(:strftime, '%B %e, %Y, %l:%M:%S %p %Z')
      end
    end

    def render_expires_at
      h.content_tag :span, class: 'time zone unprocessed', data: { utc: expires_at.to_i, raw: expires_at.to_i } do
        object.expires_at.try(:strftime, '%B %e, %Y, %l:%M:%S %p %Z')
      end
    end
  end
end