# frozen_string_literal: true

module Listeners
  class SlugsListener
    ##
    # Remove the resource from the index.
    # Updated for slug behavior to find the appropriate index
    #
    # Called when 'object.deleted' event is published
    # @param [Dry::Events::Event] event
    def on_object_deleted(event)
      object = event.payload[:object]
      return unless object.is_a?(Valkyrie::Resource)
      original_id = object.id.to_s
      Hyrax::SolrService.delete_by_query('id:"' + original_id + '" OR resource_id_ssi:"' + original_id + '" OR fedora_id_ssi:"' + original_id + '"')
      Hyrax::SolrService.commit
    end
  end
end
