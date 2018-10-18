module Monitoring
  class CheckDecorator < Draper::Decorator
    decorates_association :server

    delegate_all

    def link_long_id(scope)
      h.content_tag :span, data: { raw: long_id } do
        h.link_to long_id, link_data(scope)
      end
    end

    def link_to_s(scope)
      h.content_tag :span, data: { raw: to_s } do
        h.link_to to_s, link_data(scope)
      end
    end

    def link_server(scope)
      server.link_to_s(scope)
    end

    def link_data(scope)
      case scope
        when :admin
          [:admin, :monitoring, self]
        when :users
          [:users, account, :monitoring, self]
      end
    end

    def render_last_run_at
      h.content_tag :span, class: 'time zone unprocessed', data: { utc: last_run_at.to_i, raw: last_run_at.to_i } do
        last_run_at.try(:strftime, '%B %e, %Y, %l:%M:%S %p %Z')
      end
    end

    def render_muzzle_until
      h.content_tag :span, class: 'time zone unprocessed', data: { utc: muzzle_until.to_i, raw: muzzle_until.to_i } do
        muzzle_until.try(:strftime, '%B %e, %Y, %l:%M:%S %p %Z')
      end
    end

    def render_status_code
      h.content_tag :span, class: "label #{status_code_class}" do
        case status_code.to_sym
          when :ok
            h.content_tag :i, "", class: "fa fa-check"
          when :warning
            h.content_tag :i, "", class: "fa fa-times"
          when :critical
            h.content_tag :i, "", class: "fa fa-times"
        end
      end
    end

    def render_status_code_text
      h.content_tag :span, class: "label #{status_code_class}" do
        status_code.upcase
      end
    end

    def status_code_class
      "label-#{row_class}"
    end

    def row_class
      case status_code.to_sym
        when :ok
          "success"
        when :warning
          "warning"
        when :critical
          "danger"
        when :unknown
          "info"
      end
    end

    def render_notify_account
      if notify_account?
        h.content_tag :i, "", class: "fa fa-check"
      else
        h.content_tag :i, "", class: "fa fa-times"
      end
    end

    def render_notify_staff
      if notify_staff?
        h.content_tag :i, "", class: "fa fa-check"
      else
        h.content_tag :i, "", class: "fa fa-times"
      end
    end

    def render_active
      h.content_tag :span, class: "label #{active_class}" do
        if muzzled?
          h.content_tag :i, "", class: "fa fa-volume-off"
        elsif active?
          h.content_tag :i, "", class: "fa fa-check"
        else
          h.content_tag :i, "", class: "fa fa-times"
        end
      end
    end

    def render_active_text
      h.content_tag :span, class: "label #{active_class}" do
        if muzzled?
          "Muzzled"
        elsif active?
          "Active"
        else
          "Inactive"
        end
      end
    end

    def render_disable_reason
      if disable_reason.present?
        h.t("monitoring.checks.disable_reason.#{disable_reason}")
      end
    end

    def active_class
      if muzzled?
        'label-warning'
      elsif active?
        'label-success'
      else
        'label-danger'
      end
    end
  end
end