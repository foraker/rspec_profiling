# RSpecProfiling

Collects profiles of RSpec test suites, enabling you to identify specs
with interesting attributes. For example, find the slowest specs, or the
spec which issues the most queries.

Collected attributes include:
- git commit SHA (or SVN revision) and date
- example file, line number and description
- example status (i.e. passed or failed)
- example exception (i.e. nil if passed, reason for failure otherwise)
- example time
- query count and time
- request count and time

## Compatibility

RSpecProfiling should work with Rails >= 3.2 and RSpec >= 2.14.

## Installation

Add this line to your application's Gemfile:

```
gem 'rspec_profiling'
```

And then execute:

```
bundle
```

Require the gem to your `spec_helper.rb`.

```
require "rspec_profiling/rspec"
```

Lastly, run the installation rake tasks to initialize an empty database in
which results will be collected.

```
bundle exec rake rspec_profiling:install
```

## Usage

### Choose a version control system

Results are collected based on the version control system employed e.g. revision or commit SHA for `svn` and `git` respectively.

#### Git

By default, RspecProfiling expects Git as the version control system.

#### Subversion

RspecProfiling can be configured to use `svn` in your `spec_helper.rb`:

```Ruby
RSpecProfiling.configure do |config|
  config.vcs = RSpecProfiling::VCS::Svn
end

require "rspec_profiling/rspec"
```

#### Git / Subversion

For those with a mixed project, with some developers using `git svn` and others regular `svn`, use this configuration to detect which is being used locally and behave accordingly.

```Ruby
RSpecProfiling.configure do |config|
  config.vcs = RSpecProfiling::VCS::GitSvn
end

require "rspec_profiling/rspec"
```

### Choose a results collector

Results are collected just by running the specs.

#### SQLite3

By default, profiles are collected in an SQL database. Make sure you've
run the installation rake task before attempting.

You can review results by running the RSpecProfiling console.

```
bundle exec rake rspec_profiling:console

> results.count
=> 1970

> results.order(:query_count).last.to_s
=> "Updating my account - ./spec/features/account_spec.rb:15"
```

The console has a preloaded `results` variable.

```
results.count
> 180
```

#### CSV

You can configure `RSpecProfiling` to collect results in a CSV in your
`spec_helper.rb` file.

```Ruby
RSpecProfiling.configure do |config|
  config.collector = RSpecProfiling::Collectors::CSV
end

require "rspec_profiling/rspec"
```

By default, the CSV is output to `cat tmp/spec_benchmarks.csv`.
Rerunning spec will overwrite the file. You can customize the CSV path
to, for example, include the sample time.

```Ruby
RSpecProfiling.configure do |config|
  config.collector = RSpecProfiling::Collectors::CSV
  config.csv_path = ->{ "tmp/spec_benchmark_#{Time.now.to_i}" }
end

require "rspec_profiling/rspec"
```

#### Postgresql

You can configure `RSpecProfiling` to collect results in a Postgres database 
in your `spec_helper.rb` file.

```Ruby
RSpecProfiling.configure do |config|
  config.collector = RspecProfiling::Collectors::PSQL
  config.db_path   = 'profiling'
end
```

## Configuration Options

Configuration is performed like this:

```Ruby
RSpecProfiling.configure do |config|
  config.<option> = <something>
end
```

### Options

- `db_path` - the location of the SQLite database file
- `table_name` - the database table name in which results are stored
- `csv_path` - the directory in which CSV files are dumped

## Uninstalling

To remove the results database, run `bundle exec rake
rspec_profiling:uninstall`.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## About Foraker Labs

<img src="http://assets.foraker.com/foraker_logo.png" width="400" height="62">

This project is maintained by Foraker Labs. The names and logos of Foraker Labs are fully owned and copyright Foraker Design, LLC.

Foraker Labs is a Boulder-based Ruby on Rails and iOS development shop. Please reach out if we can [help build your product](http://www.foraker.com).
