module Dedicated
  class ServerDecorator < ApplicationDecorator
    delegate_all

    decorates_association :account
    decorates_association :events

    def link_long_id(*scope)
      h.content_tag(:span, data: { raw: long_id }) do
        h.link_to [*scope, account, :dedicated, object] do
          long_id
        end
      end
    end

    def link_hostname(*scope)
      h.content_tag(:span, data: { raw: hostname }) do
        h.link_to [*scope, account, :dedicated, object] do
          hostname
        end
      end
    end

    def link_to_s(*scope)
      h.content_tag(:span, data: { raw: to_s }) do
        h.link_to [*scope, account, :dedicated, object] do
          to_s
        end
      end
    end

    def render_termination_reason
      if object.termination_reason.present?
        I18n.t("dedicated.server.termination_reason.#{object.termination_reason}", default: object.termination_reason)
      else
        "None Provided"
      end
    end

    def render_suspension_reason
      if object.suspension_reason.present?
        I18n.t("dedicated.server.suspension_reason.#{object.suspension_reason}", default: object.suspension_reason)
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
        I18n.t("dedicated.server.state.#{object.state}")
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
  end
end