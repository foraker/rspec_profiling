require "rspec_profiling"

RSpec.configure do |config|
  config.reporter.register_listener RspecProfiling::Run.new(RspecProfiling.config.collector.new),
    :start,
    :example_started,
    :example_passed,
    :example_failed
end
