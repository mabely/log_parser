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
      { '/help_page/1' => ['126.318.035.038', '126.318.035.038', '126.318.035.038', '722.247.931.582',
                           '646.865.545.408'],
        '/home' => ['184.123.665.067', '235.313.352.950'], '/about' => ['061.945.150.735'],
        '/about/2' => ['444.701.448.104'], '/contact' => ['184.123.665.067'], '/index' => ['444.701.448.104'] }
    end

    it 'orders the log in descending order of views' do
      expect(subject.generate_report).to eq sorted_logs
    end

    it 'it prints full report for total views and unique views' do
      expect($stdout).to receive(:puts).with("\n== TOTAL VIEWS ==")
      sorted_logs.each do |route, ip_adds|
        total_views = ip_adds.count
        expect($stdout).to receive(:puts).with("#{total_views} #{route}")
      end

      expect($stdout).to receive(:puts).with("\n== UNIQUE VIEWS ==")
      sorted_logs.each do |route, ip_adds|
        unique_views = ip_adds.uniq.count
        expect($stdout).to receive(:puts).with("#{unique_views} #{route}")
      end

      subject.generate_report
    end
  end
end
