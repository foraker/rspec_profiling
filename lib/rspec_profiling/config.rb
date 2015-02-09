module RspecProfiling
  def self.configure
    yield config
  end

  def self.config
    @config ||= OpenStruct.new({
      collector:  RspecProfiling::Collectors::Database,
      db_path:    'tmp/rspec_profiling',
      table_name: 'spec_profiling_results',
      csv_path:   Proc.new { 'tmp/spec_benchmarks.csv' }
    })
  end
end
