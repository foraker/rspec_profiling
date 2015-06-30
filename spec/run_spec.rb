require "active_support/core_ext"
require "rspec_profiling/run"
require "time"
require "ostruct"

module RspecProfiling
  describe Run do
    def simulate_query(sql)
      ActiveSupport::Notifications.instrument("sql.active_record", "sql", 100, 200, 1, {
        sql: sql
      })
    end

    def simulate_request
      ActiveSupport::Notifications.instrument("process_action.action_controller", "request", 100, 400, 2, {
        view_runtime: 10
      })
    end

    describe "#run_example" do
      let(:collector) { CollectorDouble.new }
      let(:run)       { described_class.new(collector) }
      let(:result)    { collector.results.first }
      let(:commit) do
        double({
          commit: "abc123",
          time: Time.new(2012, 12, 12)
        })
      end
      let(:example) do
        ExampleDouble.new({
          file_path: "/something_spec.rb",
          line_number: 15,
          full_description: "should do something"
        })
      end

      def simulate_test_suite_run
        run.start
        run.example_started(double(example: example))
        simulate_query "SELECT * FROM users LIMIT 1;"
        simulate_query "SELECT * FROM comments WHERE user_id = 1;"
        simulate_request
        run.example_passed
      end

      before do
        stub_const("RspecProfiling::CurrentCommit", commit)
        stub_const("ActiveSupport::Notifications", Notifications.new)
        simulate_test_suite_run
      end

      it "collects a single example" do
        expect(collector.count).to eq 1
      end

      it "counts two queries" do
        expect(result.query_count).to eq 2
      end

      it "counts one request" do
        expect(result.request_count).to eq 1
      end

      it "records the file" do
        expect(result.file).to eq "/something_spec.rb"
      end

      it "records the file number" do
        expect(result.line_number).to eq 15
      end

      it "records the description" do
        expect(result.description).to eq "should do something"
      end

      it "records the time" do
        expect(result.time).to eq 500
      end

      it "records the query time" do
        expect(result.query_time).to eq 200
      end

      it "records the request time" do
        expect(result.request_time).to eq 10
      end
    end

    class CollectorDouble
      attr_reader :results

      def initialize
        @results = []
      end

      def insert(result)
        @results << OpenStruct.new(result)
      end

      def count
        results.count
      end
    end

    class ExampleDouble
      attr_reader :metadata

      def initialize(metadata)
        @metadata = metadata
      end

      def execution_result
        OpenStruct.new({
          run_time: 500,
          status: :passed
        })
      end
    end

    class Notifications
      def initialize
        @subscriptions = Hash.new { |h, k| h[k] = [] }
      end

      def subscribe(event, &block)
        @subscriptions[event].push block
      end

      def instrument(event, *args)
        @subscriptions[event].each { |callback| callback.call(*args) }
      end
    end
  end
end
