# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Hyrax::Forms::CollectionForm do
  describe 'instance' do
    subject { described_class.new(collection, ability, repository) }

    let(:collection) { Collection.new }
    let(:ability) { Ability.new(build(:user)) }
    let(:repository) { double }

    # TODO: convert this to a valkyrie test. the factory is creating a valkyrie
    # object which is why this fails now.
    xit { is_expected.not_to respond_to :alternative_title }

    describe 'calling #alternative_title' do
      it "raises a NoMethodError" do
        expect { subject.alternative_title }.to raise_error(NoMethodError)
      end
    end
  end

  describe '.terms' do
    subject { described_class.terms.sort }

    # NOTE: There shall not be alternative_title that conflicts with slugs.
    # rubocop:disable RSpec/ExampleLength
    it do
      is_expected.to match_array(
        %i[abstract
           alt
           based_near
           collection_type_gid
           contributor
           creator
           date
           date_accepted
           date_available
           date_created
           date_issued
           date_published
           date_submitted
           department
           description
           doi
           former_identifier
           funder
           identifier
           issue_number
           keyword
           language
           lat
           license
           location
           long
           managing_organisation
           note
           official_url
           output_of
           pagination
           part_of
           place_of_publication
           publication_status
           publisher
           related_url
           representative_id
           resource_type
           subject
           thumbnail_id
           title
           visibility]
      )
    end
    # rubocop:enable RSpec/ExampleLength
  end
end
