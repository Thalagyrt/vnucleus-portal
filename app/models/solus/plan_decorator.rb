module Solus
  class PlanDecorator < ApplicationDecorator
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

    def render_name
      klass = admin_only? ? 'text-danger' : ''

      h.content_tag :span, class: klass do
        name
      end
    end

    def render_amount
      h.content_tag :span, data: { raw: amount } do
        MoneyFormatter.format_amount(amount)
      end
    end

    def render_disk
      h.content_tag :span, data: { raw: disk } do
        "#{h.number_to_human_size(disk)} #{disk_type}"
      end
    end

    def render_disk_space
      h.content_tag :span, data: { raw: disk } do
        "#{h.number_to_human_size(disk)}"
      end
    end

    def render_ram
      h.content_tag :span, data: { raw: ram } do
        h.number_to_human_size(object.ram)
      end
    end

    def render_transfer
      h.content_tag :span, data: { raw: transfer } do
        h.number_to_human_size(transfer)
      end
    end

    def render_stock_icon
      if stock > 0
        h.content_tag :i, class: 'fa text-success fa-check' do
          ""
        end
      else
        h.content_tag :i, class: 'fa text-danger fa-times' do
          ""
        end
      end
    end

    def render_managed
      if managed?
        h.content_tag :i, class: 'fa text-success fa-check' do
          ""
        end
      else
        h.content_tag :i, class: 'fa text-danger fa-times' do
          ""
        end
      end
    end

    def render_monitoring
      "24/7/365"
    end

    def status_class
      case object.status.to_sym
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

    def feature_status_class
      case object.feature_status.to_sym
        when :featured
          'label-success'
        when :highlighted
          'label-warning'
        else
          'label-default'
      end
    end

    def pricing_table_feature_status_class
      case object.feature_status.to_sym
        when :highlighted
          'table-featured'
        else
          ''
      end
    end

    def render_feature_status
      h.content_tag :span, class: "label #{feature_status_class}" do
        object.feature_status_text
      end
    end
  end
end