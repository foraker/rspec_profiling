def results
  @results ||= RspecProfiling.config.collector.new.results
end
