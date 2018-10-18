module Concerns
  module SynchronizedAtDecoratorConcern
    def render_synchronized_at
      h.content_tag :span, class: 'time zone unprocessed', data: { utc: synchronized_at.to_i, raw: synchronized_at.to_i } do
        synchronized_at.try(:strftime, '%B %e, %Y, %l:%M:%S %p %Z')
      end
    end
  end
end