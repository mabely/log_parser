# Webserver Log Parser 

This is parser for server logs that will return two different reports:
- the most views in descending order
- the most unique views in descending order

## Requirements
ruby 2.6.3
bundler 1.12+
rbenv

## Setup
```bash
brew install rbenv
rbenv install
bundle install```

## Usage
`[path/to/script] [path/to/log/file]`
eg. `./log_parser.rb webserver.log`

- To run all tests `rspec`
- To run linter `rubocop`

## Approach
LogReader handles the opening and reading of the file. It reads each line and validates the entries, outputs to console when it does not match the format of a route and IP address. It creates a hash of all entries. The IP address does a dumb matchof the IP addresses in webserver.log, it does not check for standard IP addresses, only the format of those in the file. 

LogPresenter handls presentation of the report generated. LogParser is the main class that brings together these classes. 

## Improvements
- Show total views and unique views by default, add flags for showing only total views, or only unique views
- Collate all invalid log entries and return counts and entries at the end
- Suppress console output when running RSpec
- Validation checker for IP addresses to be improved
