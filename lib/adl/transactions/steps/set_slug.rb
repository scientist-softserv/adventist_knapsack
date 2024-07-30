# frozen_string_literal: true

module Adl
  module Transactions
    module Steps
      class SetSlug
        include Dry::Monads[:result]

        def call(change_set)
          return change_set if change_set.try(:aark_id).blank? && change_set.model.try(:aark_id).blank?

          change_set.slug = change_set.set_slug

          # if we add/change a slug with an existing record, previous indexes would have a different id,
          # resulting extraneous solr indexes remaining (one fedora object/resource with two solr indexes
          # to it)
          #   1) This happens when a slug gets changed from either empty or a different value
          #   2) It also apparently happens in some situations where data existed prior to the slug logic
          # This query finds everything indexed by fedora id. The new index will have id: slug
          #
          # When the slug changed or we are dealing the ActiveFedora::Persistence.delete we need to both
          # the solr doc id (which was/is the slug) and the fedora_id_ssi or resource_id_ssi (which is the
          # object's ID)
          Blacklight.default_index.connection.delete_by_query('id:"' + change_set.id.to_s + '" OR resource_id_ssi:"' + change_set.id.to_s + '" OR fedora_id_ssi:"' + change_set.id.to_s + '"')
          Blacklight.default_index.connection.commit

          Success(change_set)
        rescue NoMethodError => err
          Failure([err.message, change_set])
        end
      end
    end
  end
end
