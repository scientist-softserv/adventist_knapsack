# frozen_string_literal: true

# Generated via
#  `rails generate hyrax:work_resource ConferenceItemResource`
require 'rails_helper'
require 'hyrax/specs/shared_specs/indexers'

RSpec.describe ConferenceItemResourceIndexer do
  let(:indexer_class) { described_class }
  let(:resource) { Hyrax.persister.save(resource: ConferenceItemResource.new) }

  it_behaves_like 'a Hyrax::Resource indexer'
end
