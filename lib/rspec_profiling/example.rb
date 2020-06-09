require "benchmark"

module RspecProfiling
  class Example
    IGNORED_QUERIES_PATTERN = %r{(
      pg_table|
      pg_attribute|
      pg_namespace|
      show\stables|
      pragma|
      sqlite_master/rollback|
      ^TRUNCATE TABLE|
      ^ALTER TABLE|
      ^BEGIN|
      ^COMMIT|
      ^ROLLBACK|
      ^RELEASE|
      ^SAVEPOINT
    )}xi

    def initialize(example)
      @example = example
      @counts  = Hash.new(0)
      @event_counts = Hash.new(0)
      @event_times = Hash.new(0)
      @event_events = Hash.new()
    end

    def file
      metadata[:file_path]
    end

    def line_number
      metadata[:line_number]
    end

    def description
      metadata[:full_description]
    end

    def status
      execution_result.status
    end

    def exception
      execution_result.exception
    end

    def time
      execution_result.run_time
    end

    def query_count
      counts[:query_count]
    end

    def query_time
      counts[:query_time]
    end

    def request_count
      counts[:request_count]
    end

    def request_time
      counts[:request_time]
    end

    attr_reader :event_counts, :event_times, :event_events

    def log_query(query, start, finish)
      unless query[:sql] =~ IGNORED_QUERIES_PATTERN
        counts[:query_count] += 1
        counts[:query_time] += (finish - start)
      end
    end

    def log_request(request, start, finish)
      counts[:request_count] += 1
      counts[:request_time] += request[:view_runtime].to_f
    end

    def log_event(event_name, event, start, finish)
      event_counts[event_name] += 1
      event_times[event_name] += (finish - start)
      if verbose_record_event?(event_name)
        begin
          ((event_events[event_name] ||= []) << event.as_json)
        rescue => e
          # no op
        end
      end
    end

    private

    attr_reader :example, :counts

    def execution_result
      @execution_result ||= begin
        result = example.execution_result
        result = OpenStruct.new(result) if result.is_a?(Hash)
        result
      end
    end

    def metadata
      example.metadata
    end

    def verbose_record_event?(event_name)
      metadata[:record_events].to_a.include?(event_name)
    end
  end
end
