# frozen_string_literal: true

# Generated via
#  `rails generate curation_concerns:work GenericWork`
RSpec.describe Hyrax::GenericWorkForm do
  let(:work) { GenericWork.new }
  let(:form) { described_class.new(work, nil, nil) }
  let(:file_set) { FactoryBot.create(:file_set) }

  describe ".model_attributes" do
    subject { described_class.model_attributes(params) }

    let(:params) { ActionController::Parameters.new(attributes) }
    let(:attributes) do
      {
        title: ['foo'],
        rendering_ids: [file_set.id]
      }
    end

    it 'permits parameters' do
      expect(subject['rendering_ids']).to eq [file_set.id]
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
          admin_set_id resource_type aark_id part_of place_of_publication
          date_issued alt bibliographic_citation remote_url video_embed
        ].sort
      )
    end
  end

  include_examples("work_form")
end
