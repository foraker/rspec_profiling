require "csv"

module RspecProfiling
  module Collectors
    class CSV
      HEADERS = %w{
        branch
        commit_hash
        date
        file
        line_number
        description
        status
        exception
        time
        query_count
        query_time
        request_count
        request_time
      }

      def self.install
        # no op
      end

      def self.uninstall
        # no op
      end

      def self.reset
        # no op
      end

      def initialize(config=RspecProfiling.config)
        config.csv_path ||= 'tmp/spec_benchmarks.csv'

        @config = config
      end

      def insert(attributes)
        output << static_cells(attributes) + event_cells(attributes)
      end

      private

      attr_reader :config

      def output
        @output ||= ::CSV.open(path, "w").tap { |csv| csv << HEADERS + event_headers }
      end

      def path
        config.csv_path.call
      end

      def static_cells(attributes)
        HEADERS.map do |field|
          attributes.fetch(field.to_sym)
        end
      end

      def event_headers
        config.events.flat_map do |event|
          ["#{event}_count", "#{event}_time", "#{event}_events"]
        end
      end

      def event_cells(attributes)
        config.events.flat_map do |event|
          [attributes[:event_counts][event], attributes[:event_times][event], attributes[:event_events][event].to_json]
        end
      end
    end
  end
end
