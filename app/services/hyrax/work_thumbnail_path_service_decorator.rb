# frozen_string_literal: true

# OVERRIDE Hyrax 3.5 to use the default image for the site if no thumbnail is present
module Hyrax
  module WorkThumbnailPathServiceDecorator
    def call(object)
      return default_image unless object.thumbnail_id

      thumb = fetch_thumbnail(object)
      return unless thumb
      return call(thumb) unless thumb.is_a?(::FileSet)
      return_path(thumb)
    end
  end
end

Hyrax::WorkThumbnailPathServiceDecorator.singleton_class.prepend Hyrax::WorkThumbnailPathServiceDecorator
