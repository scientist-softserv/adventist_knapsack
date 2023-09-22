# frozen_string_literal: true

require 'spec_helper'

RSpec.describe IiifPrint::SplitPdfs::AdventistPagesToJpgsSplitter do
  describe '.call' do
    subject { described_class.call(path, suffixes: ["spec.rb"], file_set: :file_set) }

    context 'when given path ends in the given suffix' do
      let(:path) { __FILE__ }

      it { is_expected.to eq([]) }
    end

    context 'when given path does not end in the suffix' do
      let(:path) { "#{__FILE__}.hello.rb" }

      # before { allow(IiifPrint::SplitPdfs::DerivativeRodeoSplitter).to receive(:call).and_return(:mocked_split) }
      before { allow(IiifPrint::SplitPdfs::PagesToJpgsSplitter).to receive(:call).and_return(:mocked_split) }

      it { is_expected.to be(:mocked_split) }
    end
  end
end
