#!/usr/bin/ruby
# frozen_string_literal: true

# Main class for parsing the logs. Calls LogParser to read the file,
# passes that data to LogPresenter to format and print the report to console.
class LogParser
  require_relative 'log_reader'
  require_relative 'log_presenter'

  def initialize(file)
    @file = file
  end

  def call
    @reader = LogReader.new(@file)
    @file_data = @reader.parse_file(@reader.open_file)
    LogPresenter.new(@file_data).generate_report
  end
end

if $PROGRAM_NAME == __FILE__
  abort 'ERROR: file not provided' if ARGV.empty?
  abort "ERROR: expected 1 argument but received #{ARGV.size}" unless ARGV.size == 1
  LogParser.new(ARGV[0]).call
end
