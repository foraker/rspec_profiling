require "rspec_profiling"

RSpec.configure do |config|
  runner = RspecProfiling::Run.new(RspecProfiling.config.collector.new,
                                   RspecProfiling.config.vcs.new)

  config.reporter.register_listener(
    runner,
    :start,
    :example_started,
    :example_passed,
    :example_failed
  )
end
