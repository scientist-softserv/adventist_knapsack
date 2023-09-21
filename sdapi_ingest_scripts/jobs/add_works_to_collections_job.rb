# frozen_string_literal: true

require 'csv'

class AddWorksToCollectionsJob < ApplicationJob
  queue_as :relationships

  retry_on StandardError, attempts: 0

  def perform
    csv_path = "sdapi_ingest_scripts/data/articles_parent_child_relationships_final.csv"
    csv_data = File.read(csv_path)
    CSV.parse(csv_data, headers: true) do |row|
      record_data = row.to_hash.symbolize_keys
      begin
        ConvertToRelationshipJob.perform_later(record_data: record_data)
      rescue StandardError => e
        Rails.logger.error("😈😈😈 Error: #{e.message} for #{record_data[:identifier]}")
        Raven.capture_exception(e)
        raise e
      end

      Rails.logger.info("🎁🎁🎁🎁")
    end
  end
end
