module Solus
  class ServerDecorator < ApplicationDecorator
    delegate_all

    decorates_association :account
    decorates_association :events
    decorates_association :visit
    decorates_association :node
    decorates_association :cluster
    decorates_association :backup_user
    decorates_association :console_locked_by

    def link_long_id(*scope)
      h.content_tag(:span, data: { raw: long_id }) do
        h.link_to [*scope, account, :solus, object] do
          long_id
        end
      end
    end

    def link_hostname(*scope)
      h.content_tag(:span, data: { raw: hostname }) do
        h.link_to [*scope, account, :solus, object] do
          hostname
        end
      end
    end

    def link_to_s(*scope)
      h.content_tag(:span, data: { raw: to_s }) do
        h.link_to [*scope, account, :solus, object] do
          to_s
        end
      end
    end

    def render_termination_reason
      if object.termination_reason.present?
        I18n.t("solus.server.termination_reason.#{object.termination_reason}", default: object.termination_reason)
      else
        "None Provided"
      end
    end

    def render_suspension_reason
      if object.suspension_reason.present?
        I18n.t("solus.server.suspension_reason.#{object.suspension_reason}", default: object.suspension_reason)
      else
        "None Provided"
      end
    end

    def state_class
      case object.state.to_sym
        when :pending_confirmation
          'label-warning'
        when :pending_billing
          'label-warning'
        when :pending_payment
          'label-warning'
        when :pending_provision
          'label-warning'
        when :pending_completion
          'label-warning'
        when :active
          'label-success'
        when :admin_suspended
          'label-danger'
        when :automation_suspended
          'label-danger'
        else
          'label-default'
      end
    end

    def render_state
      h.content_tag :span, class: "label #{state_class}" do
        I18n.t("solus.server.state.#{object.state}")
      end
    end

    def render_node_name
      object.node_name || "N/A"
    end

    def render_root_username
      if object.root_username
        h.content_tag :span, class: 'monospace' do
          object.root_username
        end
      else
        "N/A"
      end
    end

    def render_root_password
      if object.root_password
        h.content_tag :span, class: 'monospace' do
          object.root_password
        end
      else
        "N/A"
      end
    end

    def render_console_locked_by
      if console_locked_by.present?
        console_locked_by.render_full_name
      else
        "N/A"
      end
    end

    def render_plan_name
      h.content_tag :span, data: { raw: ram } do
        plan_name
      end
    end

    def render_amount
      h.content_tag :span, data: { raw: amount } do
        render_amount_plaintext
      end
    end

    def render_amount_plaintext
      MoneyFormatter.format_amount(amount)
    end

    def render_prorated_amount
      h.content_tag :span, data: { raw: prorated_amount } do
        MoneyFormatter.format_amount(prorated_amount)
      end
    end

    def render_prorated_template_difference(template)
      h.content_tag :span, data: { raw: prorated_template_difference(template) } do
        MoneyFormatter.format_amount(prorated_template_difference(template))
      end
    end

    def render_patch_at
      if patch_at.present?
        h.content_tag :span, data: { raw: patch_at.to_time.to_i } do
          render_patch_at_plaintext
        end
      else
        h.content_tag :span, data: { raw: 0 } do
          render_patch_at_plaintext
        end
      end
    end

    def console_popup_dimensions
      case ConsolePolicy.new(server: object).type
        when :ssh
          { width: 620, height: 440 }
        when :vnc
          { width: 1070, height: 900 }
      end
    end

    def render_patch_at_plaintext
      if patch_at.present?
        patch_at.to_s
      else
        "Not Scheduled"
      end
    end

    def render_managed
      if managed?
        h.content_tag :span, "Managed", class: 'label label-success'
      else
        h.content_tag :span, "Unmanaged", class: 'label label-danger'
      end
    end

    def render_enable_smtp
      if enable_smtp?
        h.content_tag :span, "Enabled", class: 'label label-success'
      else
        h.content_tag :span, "Contact Support to Enable SMTP", class: 'label label-danger'
      end
    end

    def render_disk
      h.number_to_human_size(object.disk)
    end

    def render_used_transfer
      h.number_to_human_size(object.used_transfer)
    end

    def render_transfer
      h.number_to_human_size(object.transfer)
    end

    def render_ram
      h.number_to_human_size(object.ram)
    end

    def render_disk
      h.number_to_human_size(object.disk)
    end

    def render_coupon_code
      coupon_code.upcase
    end

    def render_whm_url
      url = "https://#{ip_address}:2087"

      h.link_to url, url, target: 'blank'
    end

    def transfer_class
      if object.used_transfer_percentage < 75
        'progress-bar-success'
      elsif object.used_transfer_percentage < 90
        'progress-bar-warning'
      else
        'progress-bar-danger'
      end
    end

    def render_install_time
      secs  = object.install_time
      mins  = secs / 60
      hours = mins / 60
      days  = hours / 24

      if days > 0
        "#{days} days and #{hours % 24} hours"
      elsif hours > 0
        "#{hours} hours and #{mins % 60} minutes"
      elsif mins > 0
        "#{mins} minutes and #{secs % 60} seconds"
      elsif secs >= 0
        "#{secs} seconds"
      end
    end
  end
end