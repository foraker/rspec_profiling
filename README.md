# RspecProfiling

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

RspecProfiling should work with Rails >= 3.2 and RSpec >= 2.14.

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

RspecProfiling can be configured to use `svn` in `config/initializers/rspec_profiling.rb`:

```Ruby
RspecProfiling.configure do |config|
  config.vcs = RspecProfiling::VCS::Svn
end
```

#### Git / Subversion

For those with a mixed project, with some developers using `git svn` and others regular `svn`, use this configuration to detect which is being used locally and behave accordingly.

```Ruby
RspecProfiling.configure do |config|
  config.vcs = RspecProfiling::VCS::GitSvn
end
```

### Choose a results collector

Results are collected just by running the specs.

#### SQLite3

By default, profiles are collected in an SQL database. Make sure you've
run the installation rake task before attempting.

You can review results by running the RspecProfiling console.
The console has a preloaded `results` variable.

```
bundle exec rake rspec_profiling:console

> results.count
=> 1970
```

You can find the spec that runs the most queries:

```
> results.order(:query_count).last.to_s
=> "Updating my account - ./spec/features/account_spec.rb:15"
```

Or find the spec that takes the most time:

```
> results.order(:time).last.to_s
=> "Updating my account - ./spec/features/account_spec.rb:15"
```

There are additional attributes available on the `Result` instances to enable
debugging, such as `exception` and `status`.

#### CSV

You can configure `RspecProfiling` to collect results in a CSV in `config/initializers/rspec_profiling.rb`:

```Ruby
RspecProfiling.configure do |config|
  config.collector = RspecProfiling::Collectors::CSV
end
```

By default, the CSV is output to `cat tmp/spec_benchmarks.csv`.
Rerunning spec will overwrite the file. You can customize the CSV path
to, for example, include the sample time.

```Ruby
RspecProfiling.configure do |config|
  config.collector = RspecProfiling::Collectors::CSV
  config.csv_path = ->{ "tmp/spec_benchmark_#{Time.now.to_i}" }
end
```

#### Postgresql

You can configure `RspecProfiling` to collect results in a Postgres database
in your `spec_helper.rb` file.

```Ruby
RspecProfiling.configure do |config|
  config.collector = RspecProfiling::Collectors::PSQL
  config.db_path   = 'profiling'
end
```

## Configuration Options

Configuration is performed like this:

```Ruby
RspecProfiling.configure do |config|
  config.<option> = <something>
end
```

### Options

- `db_path` - the location of the SQLite database file
- `table_name` - the database table name in which results are stored
- `csv_path` - the directory in which CSV files are dumped
- `collector` - collector to use

### Usage in a script

If you want to access the results from a Ruby script instead of the `rake rspec_profiling:console` shell command:

```ruby
require 'rspec_profiling'
require 'rspec_profiling/console'
```

Then `results` will be available as a variable to the script.

## Uninstalling

To remove the results database, run `bundle exec rake rspec_profiling:uninstall`.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## About Breakwater

![Breakwater Logo](https://images.squarespace-cdn.com/content/5d084fe43b0b620001239437/1565926359217-2LQ1BOFAO5846OAYAGZV/breakwater.png?content-type=image%2Fpng)

Breakwater builds exciting web and mobile apps in Louisville, CO. Our work powers a wide variety of businesses with many different needs. We love open source software, and we're proud to contribute where we can. Interested to learn more? [Contact us today](https://www.breakwaterltd.com/contact).

This project is maintained by Breakwater. The names and logos of Breakwater are fully owned and copyright Breakwater Limited.
