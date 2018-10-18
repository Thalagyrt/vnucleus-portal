module Concerns
  module TimestampDecoratorConcern
    extend ActiveSupport::Concern

    def render_created_at
      h.content_tag :span, class: 'time zone unprocessed', data: { utc: created_at.to_i, raw: created_at.to_i } do
        created_at.try(:strftime, '%B %e, %Y, %l:%M:%S %p %Z')
      end
    end

    def render_updated_at
      h.content_tag :span, class: 'time zone unprocessed', data: { utc: updated_at.to_i, raw: updated_at.to_i } do
        object.updated_at.try(:strftime, '%B %e, %Y, %l:%M:%S %p %Z')
      end
    end
  end
end