require "csv"

module RspecProfiling
  module Collectors
    class CSV
      HEADERS = %w{
        commit
        date
        file
        line_number
        description
        status
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

      def insert(attributes)
        output << HEADERS.map do |field|
          attributes.fetch(field.to_sym)
        end
      end

      private

      def output
        @output ||= ::CSV.open(path, "w").tap { |csv| csv << HEADERS }
      end

      def path
        RspecProfiling.config.csv_path.call
      end
    end
  end
end
