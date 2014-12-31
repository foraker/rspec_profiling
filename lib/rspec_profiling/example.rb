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

    private

    attr_reader :example, :counts

    def execution_result
      example.execution_result
    end

    def metadata
      example.metadata
    end
  end
end
