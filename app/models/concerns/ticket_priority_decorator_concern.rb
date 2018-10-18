module Concerns
  module TicketPriorityDecoratorConcern
    def priority_class
      case object.priority.to_sym
        when :normal
          'label-info'
        when :critical
          'label-danger'
        else
          'label-default'
      end
    end

    def render_priority
      if object.priority.present?
        h.content_tag :span, class: "label #{priority_class}", data: { raw: priority_value } do
          object.priority_text
        end
      end
    end
  end
end