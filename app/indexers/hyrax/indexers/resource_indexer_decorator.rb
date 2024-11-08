# frozen_string_literal: true

# TODO remove when https://github.com/samvera/hyrax/pull/6968 is merged
module Hyrax
  module Indexers
    ##
    # @api public
    #
    # Transforms +Valkyrie::Resource+ models to solr-ready key-value hashes. Use
    # {#to_solr} to retrieve the indexable hash.
    #
    # The default {Hyrax::Indexers::ResourceIndexer} implementation provides
    # minimal indexing for the Valkyrie id and the reserved +#created_at+ and
    # +#updated_at+ attributes.
    #
    # Custom indexers inheriting from others are responsible for providing a
    # full index hash. A common pattern for doing this is to employ method
    # composition to retrieve the parent's data, then modify it:
    # +def to_solr; super.tap { |index_doc| transform(index_doc) }; end+.
    # This technique creates infinitely composible index building behavior, with
    # indexers that can always see the state of the resource and the full
    # current index document.
    #
    # It's recommended to *never* modify the state of +resource+ in an indexer.
    class ResourceIndexerDecorator
      ##
      # @api public
      # @return [HashWithIndifferentAccess<Symbol, Object>]
      def to_solr
        {
          "id": resource.id.to_s,
          "date_uploaded_dtsi": resource.created_at,
          "date_modified_dtsi": resource.updated_at,
          "system_create_dtsi": resource.created_at,
          "system_modified_dtsi": resource.updated_at,
          "has_model_ssim": resource.to_rdf_representation,
          "human_readable_type_tesim": resource.human_readable_type,
          "human_readable_type_sim": resource.human_readable_type,
          "alternate_ids_sim": resource.alternate_ids.map(&:to_s)
        }.with_indifferent_access
      end
    end
  end
end

Hyrax::Indexers::ResourceIndexer.prepend(Hyrax::Indexers::ResourceIndexDecorator)
