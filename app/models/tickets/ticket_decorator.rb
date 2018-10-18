module Tickets
  class TicketDecorator < ApplicationDecorator
    include ::Concerns::TimestampDecoratorConcern
    include ::Concerns::TicketStatusDecoratorConcern
    include ::Concerns::TicketPriorityDecoratorConcern

    delegate_all

    decorates_association :updates
    decorates_association :account
    decorates_association :updated_by

    def render_updated_by
      if updated_by
        updated_by.render_full_name
      else
        h.content_tag :span, data: { raw: 'Unknown' } do
          "Unknown"
        end
      end
    end

    def link_updated_by(*scope)
      if updated_by
        updated_by.link_full_name(*scope)
      else
        h.content_tag :span, data: { raw: 'Unknown' } do
          "Unknown"
        end
      end
    end

    def link_long_id(*scope)
      h.content_tag :span, data: { raw: long_id } do
        h.link_to [*scope, account, object] do
          long_id
        end
      end
    end

    def link_subject(*scope)
      h.content_tag :span, data: { raw: subject } do
        h.link_to [*scope, account, object] do
          subject
        end
      end
    end

    def link_to_s(*scope)
      h.content_tag :span, data: { raw: to_s } do
        h.link_to [*scope, account, object] do
          to_s
        end
      end
    end
  end
end