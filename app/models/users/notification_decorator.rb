module Users
  class NotificationDecorator < ApplicationDecorator
    include ::Concerns::TimestampDecoratorConcern

    delegate_all

    decorates_association :target
    decorates_association :actor
    decorates_association :user

    delegate :linkable?, to: :policy_finder

    def render_message
      if linkable?
        h.link_to render_message_plaintext, [:users, object]
      else
        render_message_plaintext
      end
    end

    def render_message_plaintext
      (I18n.t("notification.message.#{object.link_policy}.#{object.message}") % { actor: render_actor, target: render_target }).html_safe
    end

    def render_icon
      if read?
        h.content_tag :span, class: 'text-success' do
          h.content_tag :i, class: 'fa fa-check fa-fw' do
            ""
          end
        end
      else
        h.content_tag :span, class: 'text-info' do
          h.content_tag :i, class: 'fa fa-info-circle fa-fw' do
            ""
          end
        end
      end
    end

    def render_mark_read
      unless read?
        h.link_to "Mark Read", [:users, object], remote: true
      end
    end

    def render_actor
      if actor.present?
        actor.render_full_name
      else
        'unknown'
      end
    end

    def render_target
      if target.present?
        target_name
      else
        'unknown'
      end
    end

    private
    def target_name
      target.try(:to_s)
    end

    def policy_finder
      @policy_finder ||= NotificationLinkPolicy::Finder.new(notification: object)
    end
  end
end