# frozen_string_literal: true

require 'spec_helper'

RSpec.describe CatalogController do
  describe 'dog biscuits induced catalog translations' do
    subject { CatalogController.blacklight_config.index_fields.fetch(given_field).label }

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
end