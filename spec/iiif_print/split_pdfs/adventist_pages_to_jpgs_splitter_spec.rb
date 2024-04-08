# frozen_string_literal: true

require 'spec_helper'

RSpec.describe IiifPrint::SplitPdfs::AdventistPagesToJpgsSplitter do
  describe '.split_this?' do
    subject { described_class.split_this?(path: path) }

    [
      ["hello.jpg", true],
      ["hello.reader.pdf", false],
      ["hello.reader.jpg", true],
      ["hello.reader.pdf.pdf", true]
    ].each do |given_path, expected_value|
      context "given #{given_path.inspect}" do
        let(:path) { given_path }

        it { is_expected.to eq(expected_value) }
      end
    end
  end

  describe '.call' do
    subject { described_class.call(path, suffixes: ["spec.rb"], file_set: create(:file_set)) }

    context 'when given path ends in the given suffix' do
      let(:path) { __FILE__ }

      it { is_expected.to eq([]) }
    end

    context 'when given path does not end in the suffix' do
      let(:path) { "#{__FILE__}.hello.rb" }

      before { allow(IiifPrint::SplitPdfs::DerivativeRodeoSplitter).to receive(:call).and_return(:mocked_split) }
      # before { allow(IiifPrint::SplitPdfs::PagesToJpgsSplitter).to receive(:call).and_return(:mocked_split) }

      it { is_expected.to be(:mocked_split) }
    end
  end
end
