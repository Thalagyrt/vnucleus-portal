module Accounts
  class NoteDecorator < ApplicationDecorator
    include ::Concerns::TimestampDecoratorConcern

    delegate_all

    decorates_association :user

    def anchor
      "#{object.id}"
    end

    def render_body
      h.content_tag :div, class: 'word-wrap' do
        h.simple_format(h.auto_link(h.h(object.body)))
      end
    end
  end
end