# frozen_string_literal: true

module Listeners
  class FileSetThumbnailListener
    def on_file_set_attached(event)
      file_set = event.payload[:file_set]
      work = Hyrax.custom_queries.find_parent_work(resource: file_set)
      return if work.thumbnail_id.present? && file_set.override_default_thumbnail != 'true'
      # add the file_set as the work's thumbnail
      work.thumbnail_id = file_set.id
      Hyrax.persister.save(resource: work)
      Hyrax.index_adapter.save(resource: work)
    end
  end
end
