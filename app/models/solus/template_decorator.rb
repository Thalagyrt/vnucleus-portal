module Solus
  class TemplateDecorator < ApplicationDecorator
    delegate_all

    def link_id(*scope)
      h.content_tag :span, data: { raw: id } do
        h.link_to id.to_s, [*scope, :solus, object]
      end
    end

    def link_name(*scope)
      h.content_tag :span, data: { raw: name } do
        h.link_to name, [*scope, :solus, object]
      end
    end

    def render_amount
      h.content_tag :span, data: { raw: amount } do
        if amount == 0
          "Free"
        else
          "#{MoneyFormatter.format_amount(amount)}/mo"
        end
      end
    end

    def status_class
      case status.to_sym
        when :active
          'label-success'
        when :hidden
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

    def render_install_time
      h.content_tag :span, data: { raw: install_time } do
        mins  = install_time / 60
        hours = mins / 60
        days  = hours / 24

        if days > 0
          "#{days} days and #{hours % 24} hours"
        elsif hours > 0
          "#{hours} hours and #{mins % 60} minutes"
        elsif mins > 0
          "#{mins} minutes and #{install_time % 60} seconds"
        elsif install_time >= 0
          "#{install_time} seconds"
        end
      end
    end
  end
end