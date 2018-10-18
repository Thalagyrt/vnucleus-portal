module Licenses
  class LicenseDecorator < ApplicationDecorator
    delegate_all

    decorates_association :account

    def render_amount
      h.content_tag :span, data: { raw: object.amount } do
        MoneyFormatter.format_amount(amount)
      end
    end

    def render_total_amount
      h.content_tag :span, data: { raw: object.total_amount } do
        MoneyFormatter.format_amount(total_amount)
      end
    end

    def render_next_due
      h.content_tag :span, data: { raw: next_due.to_time.to_i } do
        next_due.to_s
      end
    end

    def render_note
      if note.present?
        note
      else
        "N/A"
      end
    end
  end
end