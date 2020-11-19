module RspecProfiling
  module Collectors
    class JSON
      KEYS = %w{
        branch
        commit_hash
        seed
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
        start_memory
        end_memory
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
        config.output_file_path ||= 'tmp/spec_benchmarks.json'

        @config = config
      end

      def insert(attributes)
        output << merge_attributes_and_events(attributes) + "\n"
      end

      private

      attr_reader :config

      def output
        @output ||= ::File.open(path, "w")
      end

      def path
        config.output_file_path.call
      end

      def merge_attributes_and_events(attributes)
        config.events.flat_map do |event|
          attributes["#{event}_counts"] = attributes[:event_counts][event]
          attributes["#{event}_times"] = attributes[:event_times][event]
          attributes["#{event}_events"] = attributes[:event_events][event]
        end

        attributes.merge(config.additional_data)

        attributes.except(:event_counts, :event_times, :event_events, :events).to_json
      end
    end
  end
end
