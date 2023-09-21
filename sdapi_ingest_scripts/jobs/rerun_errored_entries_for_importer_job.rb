# frozen_string_literal: true

##
# This class is responsible for rescheduling all failed entry imports.
#
# @note This class is starting it's life in the Adventist repository but is being designed so that
#       we could copy it rather easily into Bulkrax.
#
# @see https://github.com/scientist-softserv/adventist-dl/issues/430
#
# @example
#   switch!('sdapi'); RerunErroredEntriesForImporterJob.perform_later(importer_id: 123, last_run_id: 456)
class RerunErroredEntriesForImporterJob < ApplicationJob
  queue_as :reimport

  retry_on StandardError, attempts: 0

  ##
  # @param importer_id [Integer]
  # @param last_run_id [Integer]
  # @param error_classes [Array<String>] only re-run for entries that had failures matching the given
  #        :error_classes.
  # @param logger [Logger]
  def perform(importer_id:, last_run_id: nil, error_classes: [], logger: Rails.logger)
    @logger = logger
    @importer = Bulkrax::Importer.find(importer_id)
    @last_run = if last_run_id
                  @importer.importer_runs.find(last_run_id)
                else
                  @importer.last_run
                end
    @error_classes = Array.wrap(error_classes).map(&:to_s)

    do_it!
  end

  attr_reader :importer, :last_run, :new_run, :logger, :error_classes

  def do_it!
    reimport_logging_context = "#{importer.class} ID=#{importer.id} with #{last_run.class} ID=#{last_run.id}"

    relation = Bulkrax::Status
               .where(
                 status_message: "Failed",
                 id: Bulkrax::Status.where(runnable: last_run, statusable_type: 'Bulkrax::Entry')
                       .group(:statusable_id, :statusable_type)
                       .select('max(ID) as id')
               )

    if error_classes.empty?
      logger.info("Starting re-importing #{reimport_logging_context} with entries that had any error.")
      relation = relation.where.not(error_class: nil)
    else
      # rubocop:disable Metrics/LineLength
      logger.info("Starting re-importing #{reimport_logging_context} with entries that had the following errors: #{error_classes.inspect}.")
      # rubocop:enable Metrics/LineLength
      relation = relation.where(error_class: error_classes)
    end

    # We need to count before we do the select narrowing; otherwise ActiveRecord will throw a SQL
    # error.
    relation_count = relation.count
    # rubocop:disable Metrics/LineLength
    logger.info("*****************Found #{relation_count} entries to re-import for #{reimport_logging_context}.*****************")
    # rubocop:enable Metrics/LineLength

    # No sense loading all the fields; we really only need these two values to resubmit the given job.
    relation = relation.select('id', 'statusable_id', 'statusable_type')
    counter = 0

    relation.find_each do |status|
      counter += 1
      # rubocop:disable Metrics/LineLength
      logger.info("Enqueuing re-import for #{reimport_logging_context} #{status.statusable_type} ID=#{status.statusable_id} (#{counter} of #{relation_count}).")
      # rubocop:enable Metrics/LineLength
      begin
        # rubocop:enable Metrics/LineLength
        RerunEntryJob.perform_later(entry_class_name: status.statusable_type, entry_id: status.statusable_id)
      rescue StandardError => e
        # rubocop:disable Metrics/LineLength
        logger.error("😈😈😈 Error: #{e.message} for #{reimport_logging_context} #{status.statusable_type} ID=#{status.statusable_id}")
        # rubocop:enable Metrics/LineLength
        raise e
      end
    end

    logger.info("Finished submitting re-imports for #{reimport_logging_context}.")
  end
end
