module RspecProfiling
  def self.configure
    yield config
  end

  def self.config
    @config ||= OpenStruct.new({
      collector:  RspecProfiling::Collectors::SQL,
      table_name: 'spec_profiling_results',
    })
  end
end
