# frozen_string_literal: true

module Adl
  module Transactions
    module Steps
      class SetSlug
        include Dry::Monads[:result]

        def call(change_set)
          return Success(change_set) if change_set.try(:aark_id).blank? && change_set.model.try(:aark_id).blank?

          change_set.slug = change_set.set_slug

          # if we add/change a slug with an existing record, previous indexes would have a different id,
          # resulting extraneous solr indexes remaining (one fedora object/resource with multiple solr indexes
          # to it)
          #   1) This happens when a slug gets changed from either empty or a different value
          #   2) It also apparently happens in some situations where data existed prior to the slug logic
          # This query finds everything indexed by the original object's id. The new index will have id: slug.
          original_id = change_set.id.to_s
          if original_id.present?
            Hyrax::SolrService.delete_by_query('id:"' + original_id + '" OR resource_id_ssi:"' + original_id + '" OR fedora_id_ssi:"' + original_id + '"')
            Hyrax::SolrService.commit
          end

          Success(change_set)
        rescue NoMethodError => err
          Failure([err.message, change_set])
        end
      end
    end
  end
end
