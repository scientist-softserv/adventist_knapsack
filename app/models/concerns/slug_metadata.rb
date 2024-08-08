# frozen_string_literal: true

module SlugMetadata
  extend ActiveSupport::Concern

  included do
    # adding aark_id to metadata, correct mapping to be completed by client
    property :aark_id,
             predicate: ::RDF::URI.intern('https://adl-hyku-staging.notch8.cloud/terms/aark_id'),
             multiple: false do |index|
               index.as :stored_searchable
             end

    # @deprecated due to inappropriate predicate overlapping alternate_title
    # adding slug field for custom work urls
    property :slug, predicate: ::RDF::Vocab::DC.alternative, multiple: false do |index|
      index.as :stored_searchable
    end
  end
end
