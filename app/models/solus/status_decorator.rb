module Solus
  class StatusDecorator < ApplicationDecorator
    delegate_all

    def render_ip_addresses
      h.content_tag :ul, class: 'list-unstyled remove-margin remove-padding' do
        if object.ip_addresses
          object.ip_addresses.map { |ip_address| h.content_tag(:li, h.content_tag(:code, ip_address), class: "ip-address") }.join(' ').html_safe
        else
          h.content_tag(:li, "N/A")
        end
      end
    end

    def power_state_class
      case object.power_state.to_sym
        when :online
          'label-success'
        when :offline
          'label-danger'
        else
          'label-default'
      end
    end

    def render_power_state
      if object.power_state
        h.content_tag :span, class: "label #{power_state_class}" do
          I18n.t("solus.server.power_state.#{object.power_state}").titleize
        end
      else
        h.content_tag :span, class: "label" do
          "N/A"
        end
      end
    end
  end
end