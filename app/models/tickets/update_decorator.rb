module Tickets
  class UpdateDecorator < ApplicationDecorator
    include ::Concerns::TimestampDecoratorConcern
    include ::Concerns::TicketStatusDecoratorConcern
    include ::Concerns::TicketPriorityDecoratorConcern

    delegate_all

    decorates_association :user
    decorates_association :ticket

    def anchor
      "#{object.sequence}"
    end

    def render_body
      h.content_tag :div, class: 'word-wrap ticket-body ticket-min-height' do
        ::Formatting::Markdown.new(sanitize_input: true, hard_wrap: true).render(object.body).html_safe
      end
    end

    def render_secure_body
      h.content_tag :div, class: 'word-wrap ticket-body' do
        ::Formatting::Markdown.new(sanitize_input: true, hard_wrap: true).render(object.secure_body).html_safe
      end
    end
  end
end