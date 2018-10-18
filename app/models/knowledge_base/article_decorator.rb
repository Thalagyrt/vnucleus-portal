module KnowledgeBase
  class ArticleDecorator < ApplicationDecorator
    include ::Concerns::TimestampDecoratorConcern

    delegate_all

    def link_id(*scope)
      h.content_tag :span, data: { raw: id } do
        h.link_to id.to_s, [*scope, :knowledge_base, object]
      end
    end

    def link_title(*scope)
      h.content_tag :span, data: { raw: title } do
        h.link_to title, [*scope, :knowledge_base, object]
      end
    end

    def link_to_s(*scope)
      h.content_tag :span, data: { raw: title } do
        h.link_to to_s, [*scope, :knowledge_base, object]
      end
    end

    def render_body
      ::Formatting::Markdown.new.render(object.body).html_safe
    end

    def render_tag_list(scope = nil)
      h.capture do
        h.content_tag :ul, class: 'tags ul-comma' do
          object.tags.each do |tag|
            h.concat h.content_tag(:li, h.link_to(tag.name, [*scope, :knowledge_base, :articles, search: tag.name]))
          end
        end
      end
    end

    def status_class
      case object.status.to_sym
        when :published
          'label-success'
        when :draft
          'label-warning'
        else
          'label-default'
      end
    end

    def render_status
      h.content_tag :span, class: "label #{status_class}" do
        object.status_text
      end
    end
  end
end