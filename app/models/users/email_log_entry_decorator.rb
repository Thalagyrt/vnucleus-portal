module Users
  class EmailLogEntryDecorator < ApplicationDecorator
    include ::Concerns::TimestampDecoratorConcern

    decorates_association :user

    delegate_all

    def render_body
      h.content_tag :div, class: 'word-wrap' do
        h.simple_format(h.auto_link(h.h(object.body), html: { target: 'blank' }), {}, sanitize: false)
      end
    end

    def link_to_param(*scope)
      h.content_tag :span, data: { raw: to_param } do
        h.link_to to_param, [*scope, object]
      end
    end
  end
end
