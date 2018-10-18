module Solus
  class UsageReport
    include ActiveModel::Model
    include Draper::Decoratable

    def initialize(opts = {})
      @usages_scope = opts.fetch(:usages_scope)
      @start_date = opts.fetch(:start_date).to_date
      @nodes_scope = opts.fetch(:nodes_scope) { Solus::Node }
      @templates_scope = opts.fetch(:templates_scope) { Solus::Template }
    end

    attr_reader :start_date

    def persisted?
      true
    end

    def id
      start_date.strftime("%Y-%m")
    end

    def to_s
      start_date.strftime("%B %Y")
    end

    def end_date
      start_date + 1.month
    end

    def templates_by_node
      @templates_by_node ||= counts.each_with_object({}) do |value, nodes|
        node_id = value[0][0]
        template_id = value[0][1]
        count = value[1]

        node = nodes_scope.find(node_id)
        template = templates_scope.find(template_id)

        nodes[node] ||= []
        nodes[node] << { template: template, count: count }
      end
    end

    def nodes_by_template
      @nodes_by_template ||= counts.each_with_object({}) do |value, templates|
        node_id = value[0][0]
        template_id = value[0][1]
        count = value[1]

        node = nodes_scope.find(node_id)
        template = templates_scope.find(template_id)

        templates[template] ||= []
        templates[template] << { node: node, count: count }
      end
    end

    private
    attr_reader :usages_scope, :nodes_scope, :templates_scope

    def usages
      usages_scope.where(created_at: start_date..end_date).where('count > 0')
    end

    def counts
      usages.group(:node_id, :template_id).maximum(:count)
    end
  end
end