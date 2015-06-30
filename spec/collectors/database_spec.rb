require "rspec_profiling/config"
require "rspec_profiling/collectors/database"

module RspecProfiling
  module Collectors
    describe Database do
      before(:all) { Database.install }
      after(:all)  { Database.uninstall }

      describe "#insert" do
        let(:collector) { described_class.new }
        let(:result)    { collector.results.first }

        before do
          collector.insert({
            commit: "ABC123",
            date: "Thu Dec 18 12:00:00 2012",
            file: "/some/file.rb",
            line_number: 10,
            description: "Some spec",
            time: 100,
            status: :passed,
            query_count: 10,
            query_time: 50,
            request_count: 1,
            request_time: 400
          })
        end

        it "records a single result" do
          expect(collector.results.count).to eq 1
        end

        it "records the commit SHA" do
          expect(result.commit).to eq "ABC123"
        end

        it "records the commit date" do
          expect(result.commit_date).to eq Time.utc(2012, 12, 18, 12)
        end

        it "records the file" do
          expect(result.file).to eq "/some/file.rb"
        end

        it "records the line number" do
          expect(result.line_number).to eq 10
        end

        it "records the description" do
          expect(result.description).to eq "Some spec"
        end

        it "records the time" do
          expect(result.time).to eq 100.0
        end

        it "records the passing status" do
          expect(result.status).to eq 'passed'
        end

        it "records the query count" do
          expect(result.query_count).to eq 10
        end

        it "records the query time" do
          expect(result.query_time).to eq 50
        end

        it "records the request count" do
          expect(result.request_count).to eq 1
        end

        it "records the request time" do
          expect(result.request_time).to eq 400
        end
      end
    end
  end
end
