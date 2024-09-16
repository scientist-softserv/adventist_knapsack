# frozen_string_literal: true

##
# A mixin for all additional Hyku applicable indexing; both Valkyrie and ActiveFedora friendly.
module SlugIndexing
  # TODO: Once we've fully moved to Valkyrie, remove the generate_solr_document and move `#to_solr`
  #      to a more conventional method def (e.g. `def to_solr`).  However, we need to tap into two
  #      different inheritance paths based on ActiveFedora or Valkyrie
  [:generate_solr_document, :to_solr].each do |method_name|
    define_method method_name do |*args, **kwargs, &block|
      super(*args, **kwargs, &block).tap do |solr_doc|
        # rubocop:disable Style/ClassCheck

        # Active Fedora refers to object
        # Specs refer to object as @object
        # Valkyrie refers to resource
        object ||= @object || resource
        solr_doc['id'] = object.to_param
        solr_doc['resource_id_ssi'] = object.id.to_s
      end
    end
  end
end
