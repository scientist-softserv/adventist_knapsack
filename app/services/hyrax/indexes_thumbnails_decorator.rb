# frozen_string_literal: true

# OVERRIDE Hyrax 2.9.0 to make collection thumbnails uploadable

module Hyrax
  module IndexesThumbnailsDecorator
    # Returns the value for the thumbnail path to put into the solr document
    # OVERRIDE HERE to enable collection thumbnail uploads
    def thumbnail_path
      # Active Fedora refers to objce
      # Specs refer to object as @object
      # Valkyrie refers to resource
      object ||= @object || resource

      if object.class == Collection && UploadedCollectionThumbnailPathService.uploaded_thumbnail?(object)
        UploadedCollectionThumbnailPathService.call(object)
      else
        self.class.thumbnail_path_service.call(object)
      end
    end
    # end OVERRIDE
  end
end

Hyrax::IndexesThumbnails.prepend Hyrax::IndexesThumbnailsDecorator
