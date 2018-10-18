module Concerns
  module DiskDecoratorConcern
    def render_available_disk
      h.content_tag :span, data: { raw: available_disk } do
        h.number_to_human_size(available_disk)
      end
    end

    def render_disk_limit
      h.content_tag :span, data: { raw: disk_limit } do
       h.number_to_human_size(object.disk_limit)
      end
    end
  end
end