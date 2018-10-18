module Blog
  class PostDecorator < ApplicationDecorator
    include ::Concerns::TimestampDecoratorConcern

    delegate_all

    decorates_association :user

    def link_title(*scope)
      h.content_tag :span, data: { raw: title } do
        if scope.empty?
          h.link_to title, frontend_path
        else
          h.link_to title, [:admin, :blog, object]
        end
      end
    end

    def frontend_path
      h.blog_post_date_path(published_at.year, published_at.month, published_at.day, to_param)
    end

    def frontend_url
      h.blog_post_date_url(published_at.year, published_at.month, published_at.day, to_param)
    end

    def render_body
      ::Formatting::Markdown.new.render(object.body).html_safe
    end

    def render_synopsis
      ::Formatting::Markdown.new.render(object.body.split(/^---/, 2)[0]).html_safe
    end

    def link_read_more
      if object.body.split(/^---/, 2)[1].present?
        if block_given?
          yield
        else
          h.link_to 'Read More', frontend_path
        end
      end
    end

    def render_tag_list(scope = nil)
      h.capture do
        h.content_tag :ul, class: 'tags ul-comma' do
          object.tags.each do |tag|
            h.concat h.content_tag(:li, h.link_to(tag.name, [*scope, :blog, :posts, search: tag.name]))
          end
        end
      end
    end

    def render_user
      user.render_full_name
    end

    def render_published_at
      if published_at.present?
        h.content_tag :span, class: 'time zone unprocessed', data: { utc: published_at.to_i, raw: published_at.to_i } do
          published_at.try(:strftime, '%B %e, %Y, %l:%M:%S %p %Z')
        end
      else
        "Unpublished"
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