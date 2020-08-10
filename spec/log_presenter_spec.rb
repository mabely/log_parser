# frozen_string_literal: true

require_relative '../log_presenter'

describe LogPresenter do
  describe '#all_views_report' do
    subject { described_class.new(logs) }

    let(:logs) do
      { '/about' => ['061.945.150.735'],
        '/about/2' => ['444.701.448.104'],
        '/contact' => ['184.123.665.067'],
        '/help_page/1' => ['126.318.035.038', '126.318.035.038', '126.318.035.038', '722.247.931.582',
                           '646.865.545.408'],
        '/home' => ['184.123.665.067', '235.313.352.950'], '/index' => ['444.701.448.104'] }
    end
    let(:sorted_logs) do
      { '/help_page/1' => 5,
        '/home' => 2, '/about' => 1,
        '/about/2' => 1, '/contact' => 1, '/index' => 1 }
    end
    let(:sorted_uniq_logs) do
      { '/help_page/1' => 3,
        '/home' => 2, '/about' => 1,
        '/about/2' => 1, '/contact' => 1, '/index' => 1 }
    end

    it 'it prints full report for total views and unique views' do
      expect($stdout).to receive(:puts).with("\n== TOTAL VIEWS ==")
      sorted_logs.each do |route, ip_count|
        expect($stdout).to receive(:puts).with("#{ip_count} #{route}")
      end

      expect($stdout).to receive(:puts).with("\n== UNIQUE VIEWS ==")
      sorted_uniq_logs.each do |route, ip_count|
        expect($stdout).to receive(:puts).with("#{ip_count} #{route}")
      end

      subject.generate_report
    end
  end
end
