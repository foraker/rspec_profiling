require "rspec_profiling/example"
require "rspec_profiling/current_commit"

module RspecProfiling
  class Run
    def initialize(collector)
      @collector = collector
    end

    def start(*args)
      start_counting_queries
      start_counting_requests
    end

    def example_started(example)
      example = example.example if example.respond_to?(:example)
      @current_example = Example.new(example)
    end

    def example_finished(*args)
      collector.insert({
        commit:        CurrentCommit.sha,
        date:          CurrentCommit.time,
        file:          @current_example.file,
        line_number:   @current_example.line_number,
        description:   @current_example.description,
        status:        @current_example.status,
        time:          @current_example.time,
        query_count:   @current_example.query_count,
        query_time:    @current_example.query_time,
        request_count: @current_example.request_count,
        request_time:  @current_example.request_time
      })
    end

    alias :example_passed :example_finished
    alias :example_failed :example_finished

    private

    attr_reader :collector

    def start_counting_queries
      ActiveSupport::Notifications.subscribe("sql.active_record") do |name, start, finish, id, query|
        @current_example.try(:log_query, query, start, finish)
      end
    end

    def start_counting_requests
      ActiveSupport::Notifications.subscribe("process_action.action_controller") do |name, start, finish, id, request|
        @current_example.try(:log_request, request, start, finish)
      end
    end
  end
end
