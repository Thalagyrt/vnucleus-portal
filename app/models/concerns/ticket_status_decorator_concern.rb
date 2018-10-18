module Concerns
  module TicketStatusDecoratorConcern
    def status_class
      case object.status.to_sym
        when :open
          'label-info'
        when :staff_reply
          'label-success'
        when :client_reply
          'label-warning'
        else
          'label-default'
      end
    end

    def render_status
      if object.status.present?
        h.content_tag :span, class: "label #{status_class}" do
          object.status_text
        end
      end
    end
  end
end