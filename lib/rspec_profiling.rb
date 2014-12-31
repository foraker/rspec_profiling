require "ostruct"
require "rails"
require "rspec_profiling/config"
require "rspec_profiling/version"
require "rspec_profiling/profiling"
require "rspec_profiling/collectors/csv"
require "rspec_profiling/collectors/database"

module RspecProfiling
  class Railtie < Rails::Railtie
    railtie_name :rspec_profiling

    rake_tasks do
      load "tasks/rspec_profiling.rake"
    end
  end
end
