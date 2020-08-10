# frozen_string_literal: true

# This class handles presentation of the logs to console. It takes logs read from file,
# counts the totals and prints the full report to console.
class LogPresenter
  def initialize(logs)
    @logs = logs
  end

  def generate_report
    sorted_desc_logs = sort_desc(@logs)
    output_results(sorted_desc_logs, false)
    output_results(sorted_desc_logs, true)
  end

  private

  def sort_desc(_log)
    @logs.sort_by { |_route, ip_add| -ip_add.count }.to_h
  end

  def output_results(sorted_logs, uniq_views)
    $stdout.puts "\n== #{uniq_views ? 'UNIQUE VIEWS' : 'TOTAL VIEWS'} =="
    sorted_logs.each do |route, ip_adds|
      $stdout.puts "#{uniq_views ? ip_adds.uniq.count : ip_adds.count} #{route}"
    end
  end
end
