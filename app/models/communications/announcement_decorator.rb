module Communications
  class AnnouncementDecorator < ApplicationDecorator
    include ::Concerns::TimestampDecoratorConcern

    delegate_all

    decorates_association :sent_by

    def link_id(*scope)
      h.content_tag :span, data: { raw: id } do
        h.link_to id.to_s, [*scope, :communications, object]
      end
    end

    def link_subject(*scope)
      h.content_tag :span, data: { raw: subject } do
        h.link_to subject, [*scope, :communications, object]
      end
    end

    def link_to_s(*scope)
      h.content_tag :span, data: { raw: to_s } do
        h.link_to to_s, [*scope, :communications, object]
      end
    end

    def render_body
      h.content_tag :div, class: 'word-wrap' do
        h.simple_format(h.auto_link(h.h(object.body), html: { target: 'blank' }), {}, sanitize: false)
      end
    end

    def render_sent_at
      if object.sent?
        h.content_tag :span, class: 'time zone unprocessed', data: { utc: sent_at.to_i, raw: sent_at.to_i } do
          sent_at.try(:strftime, '%B %e, %Y, %l:%M:%S %p %Z')
        end
      else
        h.content_tag :span, data: { raw: Time.zone.now.to_i } do
          "N/A"
        end
      end
    end

    def render_announcement_type
      h.content_tag :span, class: "label #{announcement_type_class}", data: { raw: announcement_type.to_s } do
        announcement_type.to_s.titleize
      end
    end

    def announcement_type_class
      case announcement_type.to_sym
        when :security_bulletin
          'label-danger'
        when :service_announcement
          'label-warning'
        else
          'label-info'
      end
    end

    def render_sent_by
      if sent_by
        sent_by.render_full_name
      else
        h.content_tag :span, data: { raw: 'N/A' } do
          "N/A"
        end
      end
    end

    def status_class
      if object.sent?
        'label-success'
      else
        'label-warning'
      end
    end

    def render_unsubscribe(user)
      case announcement_type.to_sym
        when :service_announcement
          "You are receiving this notice because you have active service with us and this message contains information related to your service."
        else
          "If you no longer wish to receive these emails, you can visit #{h.polymorphic_url [:new, :users, :unsubscription], email: user.email} and update your preferences."
      end
    end

    def render_status
      h.content_tag :span, class: "label #{status_class}" do
        object.sent? ? "Sent" : "Unsent"
      end
    end
  end
end