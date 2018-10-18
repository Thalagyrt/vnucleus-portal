module Users
  class UserDecorator < ApplicationDecorator
    delegate_all

    decorates_association :account_memberships
    decorates_association :accounts
    decorates_association :current_accounts

    def state_class
      case object.state.to_sym
        when :active
          'label-success'
        when :banned
          'label-danger'
        else
          'label-default'
      end
    end

    def render_state
      h.content_tag :span, class: "label #{state_class}" do
        object.state.to_s.titleize
      end
    end

    def render_is_staff
      object.is_staff ? "Yes" : "No"
    end

    def render_profile_complete
      object.profile_complete ? "Yes" : "No"
    end

    def render_email_confirmed
      object.email_confirmed ? "Yes" : "No"
    end

    def render_legal_accepted
      object.legal_accepted ? "Yes" : "No"
    end

    def render_active_at
      h.content_tag :span, class: 'time zone unprocessed', data: { utc: active_at.to_i, raw: active_at.to_i } do
        active_at.try(:strftime, '%B %e, %Y, %l:%M:%S %p %Z')
      end
    end

    def render_full_name
      h.content_tag :span, class: 'user', data: { raw: "#{last_name}.#{first_name}" } do
        if is_staff?
          h.concat full_name
          h.concat h.content_tag(:span, class: 'badge badge-staff', data: { toggle: 'tooltip', "original-title" => 'Staff' }) { "S" }
        else
          full_name
        end
      end
    end

    def link_id(*scope)
      h.content_tag :span, data: { raw: id } do
        h.link_to [*scope, object] do
          id.to_s
        end
      end
    end

    def link_full_name(*scope)
      h.content_tag :span, class: 'user', data: { raw: "#{last_name}.#{first_name}" } do
        h.link_to [*scope, object] do
          if is_staff?
            h.concat full_name
            h.concat h.content_tag(:span, class: 'badge badge-staff', data: { toggle: 'tooltip', "original-title" => 'Staff' }) { "S" }
          else
            full_name
          end
        end
      end
    end
  end
end