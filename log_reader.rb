# frozen_string_literal: true

# Opens the log file, parses the lines into a hash of routes with all ip addresses.
# All invalid entries are skipped and a message printed to console.
class LogReader
  def initialize(file)
    @file = file
    @data = nil
  end

  def open_file
    abort 'ERROR: file not found' unless File.exist? @file

    begin
      file = File.open(@file)
      data = file.readlines
      file.close
      data.map(&:chomp)
    rescue Errno::ENOENT => e
      warn "Error opening file: #{e}"
    end
  end

  def parse_file(file_contents)
    file_contents.each_with_object({}) do |log, result|
      route, ip_add = log.split(' ')
      output_invalid_message(log) and next unless valid_entry?(route, ip_add)

      result.key?(route) ? (result[route] << ip_add) : (result[route] = [ip_add])
    end
  end

  private

  def valid_entry?(route, ip_add)
    %r{/{1}\w+}.match?(route) && /^\d{3}\.\d{3}\.\d{3}\.\d{3}$/.match?(ip_add)
  end

  def output_invalid_message(log)
    $stdout.puts "Incorrect log entry encountered: #{log}"
  end
end

p 'running from the actual file' if $PROGRAM_NAME == __FILE__
