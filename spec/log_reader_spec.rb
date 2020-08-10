# frozen_string_literal: true

require_relative '../log_reader'

describe LogReader do
  describe '#parse_file' do
    subject { described_class.new('spec/fixtures/webserver_test.log') }

    context 'when an invalid log entry is encountered' do
      context 'when the route is invalid' do
        let(:log_array) { ['// 126.318.035.038', '/home 184.123.665.067'] }

        it 'writes to stdout' do
          expect($stdout).to receive(:puts).with("Incorrect log entry encountered: #{log_array[0]}")
          subject.parse_file(log_array)
        end
      end

      context 'when the ip address is invalid' do
        let(:log_array) { ['/help_page/1 12.318.035.038', '/home 184.123.665.067'] }

        it 'writes to stdout' do
          expect($stdout).to receive(:puts).with("Incorrect log entry encountered: #{log_array[0]}")
          subject.parse_file(log_array)
        end
      end
    end

    context 'when the log contents are in a valid format' do
      let(:log_array) do
        ['/help_page/1 126.318.035.038', '/help_page/1 126.318.035.038', '/contact 184.123.665.067',
         '/home 184.123.665.067', '/about/2 444.701.448.104', '/help_page/1 929.398.951.889',
         '/index 444.701.448.104', '/help_page/1 722.247.931.582', '/about 061.945.150.735',
         '/help_page/1 646.865.545.408', '/home 235.313.352.950']
      end

      it 'returns a hash with routes and ip addresses' do
        expected_result = { '/about' => ['061.945.150.735'],
                            '/about/2' => ['444.701.448.104'],
                            '/contact' => ['184.123.665.067'],
                            '/help_page/1' => ['126.318.035.038', '126.318.035.038', '929.398.951.889',
                                               '722.247.931.582', '646.865.545.408'],
                            '/home' => ['184.123.665.067', '235.313.352.950'], '/index' => ['444.701.448.104'] }
        expect(subject.parse_file(log_array)).to eq expected_result
      end

      it 'does not write to stdout' do
        expect($stdout).not_to receive(:puts)
        subject.parse_file(log_array)
      end
    end
  end

  describe '#open_file' do
    context 'when the file is found' do
      subject { described_class.new('spec/fixtures/webserver_test.log').open_file }

      it 'returns contents of the file' do
        file_contents = ['/help_page/1 126.318.035.038', '/help_page/1 126.318.035.038', '/contact 184.123.665.067',
                         '/home 184.123.665.067', '/about/2 444.701.448.104', '/help_page/1 929.398.951.889',
                         '/help_page/1 722.247.931.582', '/about 061.945.150.735', '/help_page/1 646.865.545.408',
                         '/home 235.313.352.950']
        expect(subject).to eq file_contents
      end
    end

    context 'when it fails to open the file' do
      subject { described_class.new('webserver_test.log') }

      before do
        allow(subject).to receive(:open_file) { raise Errno::ENOENT }
      end

      it 'catches the Errno error' do
        expect { subject.open_file }.to raise_error Errno::ENOENT
      end
    end

    context 'when the file is not found' do
      subject { described_class.new('non_existent_file.log') }

      it 'exits' do
        expect { subject.open_file }.to raise_error SystemExit
      end

      it 'writes to stderr' do
        expect($stderr).to receive(:puts).with('ERROR: file not found')
        subject.open_file
      end
    end
  end
end
