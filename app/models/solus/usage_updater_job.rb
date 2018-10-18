module Solus
  class UsageUpdaterJob
    def perform
      templates.each do |template|
        nodes.each do |node|
          recorder_for(template, node).record
        end
      end
    end

    private
    def recorder_for(template, node)
      UsageRecorder.new(template: template, node: node)
    end

    def templates
      Solus::Template.all
    end

    def nodes
      Solus::Node.all
    end
  end
end