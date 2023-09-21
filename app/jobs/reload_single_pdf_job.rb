# frozen_string_literal: true

##
# This job give the ability to reprocess works where PDF splitting failed
# Given one work, it:
# - Finds the bulkrax entry for the import
# - Removes ALL filesets, child works, and pending children
# - Removes pending relationships
# - rebuilds the work's bulkrax entry
class ReloadSinglePdfJob < ApplicationJob
  queue_as :reimport

  retry_on StandardError, attempts: 0

  ##
  # @param work [CurationConcern]: a work model object
  # @param logger [Logger]
  def perform(work:, logger: Rails.logger)
    @logger = logger
    @logger.info("🪖 Processing work #{work.to_param}")

    # locate bulkrax work entry
    entry = Bulkrax::Entry.find_by(identifier: work.identifier.first)
    if entry
      process_work(work: work, entry: entry)
    else
      @logger.info("🚫 Bulkrax::Entry not found for #{work.to_param}")
      raise BulkraxEntryNotFound
    end
  end

  def process_work(work:, entry:)
    # destroy pending relationships & stray children
    pending_relationships = IiifPrint::PendingRelationship.where(parent_id: work.id)
    if pending_relationships.any?
      destroy_potential_children_for(pending_relationships)
      pending_relationships.each(&:destroy)
    end

    # destroy child works if any
    work.child_works&.each { |child| child.destroy(eradicate: true) }

    # destroy file set(s)
    work.file_sets&.each { |fs| fs.destroy(eradicate: true) }

    # rerun entry
    @logger.info("💯 Submitting re-import of work #{work.to_param} via entry #{entry.class} ID=#{entry.id}")

    entry.build
    entry.save
    # not sure why this is needed
    work = entry.factory.find
    work.save
  rescue StandardError => e
    @logger.error("😈😈😈 Reimport error: #{e.message} for #{work.to_param}")
    raise e
  end

  def destroy_potential_children_for(pending_relationships)
    pending_relationships.each do |pending|
      child = ActiveFedora::Base.where(title_tesim: [pending.child_title])
      next unless child
      child.each do |rcd|
        rcd.destroy(eradicate: true)
      end
    end
  end

  class BulkraxEntryNotFound < StandardError; end
end
