# frozen_string_literal: true

class ConvertToRelationshipJob < ApplicationJob
  queue_as :relationships

  retry_on StandardError, attempts: 0

  def perform(record_data:)
    work = record_data[:model].constantize.where(identifier: record_data[:identifier]).first
    collection = Collection.where(identifier: record_data[:parents]).first

    return if work.blank? && collection.blank?
    return if work.member_of_collection_ids.include?(collection.id)

    collection.try(:reindex_extent=, Hyrax::Adapters::NestingIndexAdapter::LIMITED_REINDEX)
    work.member_of_collections << collection
    work.save!
    Rails.logger.info("🦄🪺👩‍👩‍👧‍👦 #{record_data[:identifier]} processed")
  end
end
