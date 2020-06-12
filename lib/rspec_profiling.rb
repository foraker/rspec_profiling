require "ostruct"
require "rails"
require "rspec_profiling/config"
require "rspec_profiling/version"
require "rspec_profiling/run"
require "rspec_profiling/collectors/csv"
require "rspec_profiling/vcs/git"
require "rspec_profiling/vcs/svn"
require "rspec_profiling/vcs/git_svn"

begin
  require "rspec_profiling/collectors/sql"
rescue LoadError
  #no op
end

begin
  require "rspec_profiling/collectors/psql"
rescue LoadError
  #no op
end



module RspecProfiling
  class Railtie < Rails::Railtie
    railtie_name :rspec_profiling

    rake_tasks do
      load "tasks/rspec_profiling.rake"
    end
  end
end

RSpecProfiling = RspecProfiling
