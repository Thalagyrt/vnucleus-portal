module Admin
  class Analytics
    include ActiveModel::Model
    include Draper::Decoratable

    attr_reader :solus_servers, :visits

    def initialize(opts = {})
      @solus_servers = opts.fetch(:solus_servers)
      @visits = opts.fetch(:visits)
    end

    concerning :Conversions do
      def conversions_by_source
        process_utm_data conversions_scope.joins(:visit)
      end

      def conversions_by_source_since(start)
        process_utm_data conversions_scope.where('solus_servers.created_at > ?', start).joins(:visit)
      end

      private
      def conversions_scope
        solus_servers.find_conversions
      end
    end

    concerning :Visits do
      def visits_by_source
        process_utm_data visits
      end

      def visits_by_source_since(start)
        process_utm_data visits.where('created_at > ?', start)
      end

      def visits_by_day_since(start)
        visits.where('created_at > ?', start).group('created_at::date').count.sort
      end
    end

    private
    def process_utm_data(scope)
      Hash[stringify_utm_hash(scope)]
    end

    def stringify_utm_hash(scope)
      utm_hash(scope).map { |k, v| process_utm_element(k, v) }
    end

    def process_utm_element(k, v)
      [k.map { |v| v || '_' }.join('/'), v]
    end

    def utm_hash(scope)
      scope.group(:utm_medium, :utm_source, :utm_campaign).count
    end
  end
end