module Solus
  class NodeDecorator < ApplicationDecorator
    include ::Concerns::RamDecoratorConcern
    include ::Concerns::DiskDecoratorConcern
    include ::Concerns::SynchronizedAtDecoratorConcern

    decorates_association :cluster

    delegate_all

    def render_locked
      if locked?
        h.content_tag :span, class: 'label label-danger' do
          "Locked"
        end
      else
        h.content_tag :span, class: 'label label-success' do
          "Active"
        end
      end
    end

    def render_available_ipv4
      h.content_tag :span, data: { raw: available_ipv4 } do
        available_ipv4.to_s
      end
    end

    def render_available_ipv6
      h.content_tag :span, data: { raw: available_ipv6 } do
        available_ipv6.to_s
      end
    end
  end
end