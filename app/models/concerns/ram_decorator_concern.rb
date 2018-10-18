module Concerns
  module RamDecoratorConcern
    def render_available_ram
      h.content_tag :span, data: { raw: available_ram } do
        h.number_to_human_size(available_ram)
      end
    end

    def render_ram_limit
      h.content_tag :span, data: { raw: ram_limit } do
        h.number_to_human_size(ram_limit)
      end
    end
  end
end