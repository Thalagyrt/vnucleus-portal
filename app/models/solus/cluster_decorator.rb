module Solus
  class ClusterDecorator < ApplicationDecorator
    include ::Concerns::RamDecoratorConcern
    include ::Concerns::DiskDecoratorConcern
    include ::Concerns::SynchronizedAtDecoratorConcern

    decorates_association :nodes

    def link_id(*scope)
      h.content_tag :span, data: { raw: id } do
        h.link_to id.to_s, [*scope, :solus, object]
      end
    end

    def link_name(*scope)
      h.content_tag :span, data: { raw: name } do
        h.link_to name, [*scope, :solus, object]
      end
    end

    def render_hostname
      h.link_to hostname, "https://#{hostname}:5656/admincp"
    end

    delegate_all
  end
end