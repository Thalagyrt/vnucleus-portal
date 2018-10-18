module Solus
  class UsageRecorder
    def initialize(opts = {})
      @node = opts.fetch(:node)
      @template = opts.fetch(:template)
      @servers = opts.fetch(:servers) { Solus::Server.find_active.where(template: template, node: node) }
    end

    def record
      Rails.logger.info { "Template #{template} has #{count} active servers on node #{node}" }

      node.usages.create(template: template, count: count)
    end

    private
    attr_reader :node, :template, :servers

    def count
      @count ||= servers.count
    end
  end
end