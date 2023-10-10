# frozen_string_literal: true

require 'spec_helper'

RSpec.describe CatalogController do
  describe '.blacklight_config' do
    subject(:blacklight_config) { described_class.blacklight_config }

    its(:search_builder_class) { is_expected.to eq(AdvSearchBuilder) }

    describe 'dog biscuits induced catalog translations' do
      subject { blacklight_config.index_fields.fetch(given_field).label }

      [
        ["title_tesim", "Title"],
        ["creator_tesim", "Author"],
        ["part_of_tesim", "Part of"],
        ["date_issued_tesim", "Date"],
        ["subject_tesim", "Subject"],
        ["source_tesim", "Source"]
      ].each do |field, label|
        context field.to_s do
          let(:given_field) { field }

          it { is_expected.to eq(label) }
        end
      end
    end

    describe 'solr dictionaries' do
      it 'does not specified spellcheck.dictionaries' do
        # rubocop:disable Metrics/LineLength
        expect(blacklight_config.search_fields).to(be_none { |_field, config| config&.solr_parameters&.key?('spellcheck.dictionaries'.to_sym) })
        # rubocop:enable Metrics/LineLength
      end
    end
  end
end
