require "rspec_profiling/example"
require "rspec_profiling/vcs/git"
require "rspec_profiling/vcs/svn"
require "rspec_profiling/vcs/git_svn"
require "rspec_profiling/collectors/sql"
require "rspec_profiling/collectors/psql"
require "rspec_profiling/collectors/csv"

module RspecProfiling
  class Run
    def initialize(collector = RspecProfiling.config.collector.new,
                   vcs = RspecProfiling.config.vcs.new)

      @collector = collector
      @vcs       = vcs
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
        branch:        vcs.branch,
        commit_hash:   vcs.sha,
        date:          vcs.time,
        file:          @current_example.file,
        line_number:   @current_example.line_number,
        description:   @current_example.description,
        status:        @current_example.status,
        exception:     @current_example.exception,
        time:          @current_example.time,
        query_count:   @current_example.query_count,
        query_time:    @current_example.query_time,
        request_count: @current_example.request_count,
        request_time:  @current_example.request_time
      })
    end

    alias :example_passed :example_finished
    alias :example_failed :example_finished

    def stop(*)
      collector.stop
    end

    private

    attr_reader :collector, :vcs

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
