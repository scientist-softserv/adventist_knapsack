# frozen_string_literal: true

# Generated via
# `rails generate hyrax:work Image`

RSpec.describe Hyrax::ImageForm do
  let(:work) { Image.new }
  let(:form) { described_class.new(work, nil, nil) }
  let(:file_set) { FactoryBot.create(:file_set) }

  describe ".model_attributes" do
    subject { described_class.model_attributes(params) }

    let(:params) { ActionController::Parameters.new(attributes) }
    let(:attributes) do
      {
        title: ['foo'],
        extent: ['extent']
      }
    end

    it 'permits parameters' do
      expect(subject['extent']).to eq ['extent']
    end
  end

  describe '.terms' do
    it 'returns an array of inherited and custom terms' do
      expect(described_class.terms.sort).to eq(
        %i[
          title creator contributor description keyword abstract
          license rights_statement publisher date_created
          subject language identifier based_near related_url
          representative_id thumbnail_id rendering_ids files
          visibility_during_embargo embargo_release_date visibility_after_embargo
          visibility_during_lease lease_expiration_date visibility_after_lease
          visibility ordered_member_ids source in_works_ids member_of_collection_ids
          admin_set_id resource_type extent aark_id part_of place_of_publication
          date_issued alt bibliographic_citation remote_url
        ].sort
      )
    end
  end

  include_examples("work_form")
end
