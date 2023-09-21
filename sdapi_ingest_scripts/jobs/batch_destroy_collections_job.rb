# frozen_string_literal: true

class BatchDestroyCollectionsJob < ApplicationJob
  queue_as :destroy_collections

  def perform
    collection_count = Collection.count
    counter = 0

    Collection.find_each do |collection|
      next if collection.title.first == 'Journal of Adventist Education'

      DestroyCollectionsJob.perform_later(collection.id)
      counter += 1
      Rails.logger.info "#{counter} of #{collection_count} collections were submitted!"
    end
  end
end
