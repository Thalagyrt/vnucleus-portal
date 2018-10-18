module Admin
  class AnalyticsDecorator < ApplicationDecorator
    delegate_all

    def render_conversions_by_source
      render_dictionary(object.conversions_by_source)
    end

    def render_conversions_by_source_since(start)
      render_dictionary(object.conversions_by_source_since(start))
    end

    def render_visits_by_source
      render_dictionary(object.visits_by_source)
    end

    def render_visits_by_source_since(start)
      render_dictionary(object.visits_by_source_since(start))
    end

    private
    def render_dictionary(terms)
      output = "".html_safe

      terms.each do |source, conversions|
        output = output + h.content_tag(:tr) do
          h.content_tag(:th, source) + h.content_tag(:td, conversions)
        end
      end

      output
    end
  end
end