# frozen_string_literal: true

require_relative '../log_parser'

describe LogParser do
  describe '#call' do
    subject { described_class.new(path) }

    let(:path) { 'spec/fixtures/webserver_test.log' }
    let(:reader) { double :reader, file: 'spec/fixtures/webserver_test.log' }
    let(:results_hash) { { '/about/2' => ['444.701.448.104'], '/contact' => ['184.123.665.067'] } }
    let(:presenter) { double :presenter, logs: results_hash }

    before do
      allow(LogReader).to receive(:new).with(path) { reader }
      allow(reader).to receive(:open_file) { results_hash }
      allow(reader).to receive(:parse_file) { results_hash }
      allow(LogPresenter).to receive(:new).with(results_hash) { presenter }
      allow(presenter).to receive(:generate_report)
    end

    it 'calls the LogReader' do
      expect(LogReader).to receive(:new).with(path)
      subject.call
    end

    it 'calls the LogPresenter' do
      expect(LogPresenter).to receive(:new).with(results_hash)
      subject.call
    end
  end
end
