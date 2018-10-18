module Common
  module WisperMatchers
    class ShouldPublish
      def initialize(publisher, event)
        @publisher = publisher
        @event = event
      end

      def matches?(block)
        published = false
        @publisher.on(@event) { published = true }

        block.call

        published
      end

      def supports_block_expectations?
        true
      end

      def failure_message
        "expected #{@publisher.class.name} to publish #{@event} event"
      end

      def failure_message_when_negated
        "expected #{@publisher.class.name} not to publish #{@event} event"
      end
    end

    def publish_event(publisher, event)
      ShouldPublish.new(publisher, event)
    end
  end
end