# frozen_string_literal: true

require 'spec_helper'

RSpec.describe FileSetsReprocessJob, clean: true do
  let(:user) { FactoryBot.create(:user) }
  let(:file_set) { FactoryBot.create(:file_with_work, content: file_content, user: user, label: 'latex.pdf') }
  let(:file_content) { File.open(fixture_path + '/latex.pdf') }

  describe '#perform' do
    it 'submits jobs' do
      expect(described_class::ConditionallyResplitFileSetJob).to receive(:perform_later).with(file_set_id: file_set.id)
      file_set

      described_class.perform_now
      # Verifying that we found one record to consider resplitting.
    end
  end

  describe 'ConditionallyResplitFileSetJob#perform' do
    describe '#perform' do
      it 'submits IiifPrint::Jobs::RequestSplitPdfJob' do
        file_set

        expect(IiifPrint::Jobs::RequestSplitPdfJob)
          .to receive(:perform_later)
          .with(file_set: file_set, user: User.batch_user)
        FileSetsReprocessJob::ConditionallyResplitFileSetJob.perform_now(file_set_id: file_set.id)
      end
    end
  end
end
