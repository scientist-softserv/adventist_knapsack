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

    # @deprecated
    # adding slug field for custom work urls
    property :slug, predicate: ::RDF::Vocab::DC.alternative, multiple: false do |index|
      index.as :stored_searchable
    end

    # We need to move the above :slug from ::RDF::Vocab::DC.alternative to a different predicate.
    #
    # This is an internal application-only custom identifier for the use of slugs'
    # It is important not to reuse any terms on the fedora items, as one would overwrite the other.
    # This creates an internal term specifically for slug use which will never get overwritten.
    property(
      :slug_for_upgrade,
      # NOTE: this is a made up URI; we don't need it to resolve to an actual page.
      predicate: ::RDF::URI.intern('http://id.loc.gov/vocabulary/identifiers/slug'),
      multiple: false
    ) { |index| index.as :stored_searchable }
  end
end
