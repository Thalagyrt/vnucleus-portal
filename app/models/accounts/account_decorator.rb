module Accounts
  class AccountDecorator < ApplicationDecorator
    include ::Concerns::TimestampDecoratorConcern

    delegate_all

    decorates_association :visit
    decorates_association :referrer
    decorates_association :notes
    decorates_association :memberships

    def link_long_id(*scope)
      h.content_tag :span, data: { raw: long_id } do
        h.link_to [*scope, object] do
          long_id
        end
      end
    end

    def link_name(*scope)
      h.content_tag :span, data: { raw: name } do
        h.link_to [*scope, object] do
          name
        end
      end
    end

    def link_to_s(*scope)
      h.content_tag :span, data: { raw: to_s } do
        h.link_to [*scope, object] do
          to_s
        end
      end
    end

    def render_member_names
      output = ''.html_safe

      memberships.each do |membership|
        output = output + h.link_to([:admin, membership.user], target: :blank) do
          h.content_tag(:span, class: 'label label-info') do
            h.concat h.content_tag :i, '', class: 'fa fa-user'
            h.concat ' '
            h.concat membership.user.full_name
            h.concat ' '
            h.concat "(#{membership.render_roles})"
          end
        end + ' '
      end

      output
    end

    def render_server_names
      output = ''.html_safe

      current_solus_servers.each do |server|
        output = output + h.link_to([:admin, self, :solus, server], target: :blank) do
          h.content_tag(:span, class: 'label label-info') do
            h.concat h.content_tag :i, '', class: 'fa fa-hdd-o'
            h.concat ' '
            h.concat server.to_s
          end
        end + ' '
      end

      current_dedicated_servers.each do |server|
        output = output + h.link_to([:admin, self, :dedicated, server], target: :blank) do
          h.content_tag(:span, class: 'label label-info') do
            h.concat h.content_tag :i, '', class: 'fa fa-server'
            h.concat ' '
            h.concat server.to_s
          end
        end + ' '
      end

      output
    end

    def render_legacy_text
      "Your account has #{legacy_solus_server_count} #{'server'.pluralize(legacy_solus_server_count)} on our legacy platform. Try our new SSD servers for better performance!"
    end

    def render_total_ram
      h.number_to_human_size(object.total_ram)
    end

    def render_total_disk
      h.number_to_human_size(object.total_disk)
    end

    def render_monthly_rate
      h.content_tag :span, data: { raw: object.monthly_rate } do
        MoneyFormatter.format_amount(object.monthly_rate)
      end
    end

    def render_referral_income
      MoneyFormatter.format_amount(object.referral_income)
    end

    def render_referrer
      if referrer.present?
        h.link_to referrer.to_s, [:admin, referrer]
      end
    end

    def render_balance
      h.content_tag :span, data: { raw: object.balance } do
        render_balance_plaintext
      end
    end

    def render_balance_plaintext
      MoneyFormatter.format_amount(object.balance)
    end

    def render_total_income
      MoneyFormatter.format_amount(object.total_income)
    end

    def render_stripe_expiration_date
      object.stripe_expiration_date.strftime("%m/%Y")
    end

    def state_class
      case object.state.to_sym
        when :active
          'label-success'
        when :pending_billing_information
          'label-warning'
        when :pending_activation
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

    def render_maxmind_response
      h.content_tag :table, class: 'table table-condensed table-definitions' do
        maxmind_response.each do |k,v|
          next unless v.present?

          h.concat(
              h.content_tag(:tr) do
                h.concat h.content_tag :th, k
                h.concat h.content_tag :td, v
              end
          )
        end
      end
    end
  end
end