module Ahoy
  class EventDecorator < ApplicationDecorator
    delegate_all

    decorates_association :user

    def render_time
      h.content_tag :span, data: { raw: time.to_i, utc: time.to_i }, class: 'time zone unprocessed' do
        time.try(:strftime, '%B %e, %Y, %l:%M:%S %p %Z')
      end
    end

    def render_properties
      h.content_tag :table, class: 'table table-condensed table-definitions' do
        properties.each do |k,v|
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