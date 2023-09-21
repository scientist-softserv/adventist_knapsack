# frozen_string_literal: true

##
# This job give the ability to rerun ingests where PDF splitting failed on a Bulkrax import.
# @example
#   switch!('sdapi'); ReloadPdfsToSplitJob.perform_later(work_type: "GenericWork")
class ReloadPdfsToSplitJob < ApplicationJob
  queue_as :reimport

  retry_on StandardError, attempts: 0

  ##
  # @param id [String]: uuid or slug or nil
  # @param work_type [String] work class
  # @param logger [Logger]
  def perform(id: nil, work_type: "JournalArticle", logger: Rails.logger)
    @logger = logger
    @context = ""
    @counter = 0

    if id.present?
      process_single(id)
    else
      process_work_type(work_type)
    end

    logger.info("🚀🚀🚀 Finished submitting re-imports. Processed #{@counter} works")
  end

  attr_reader :logger

  def process_single(id)
    @context = "id: #{id}"
    work = ActiveFedora::Base.find(id)
    do_cleanup!(work)
  rescue StandardError
    logger.info("🚫 Work not found for #{@context}")
  end

  def process_work_type(work_type)
    @context = "worktype: #{work_type}"

    work_type.constantize.find_each do |w|
      @context = "worktype: #{work_type}, work: #{w.to_param}"

      # does this work have pdf filesets?
      next unless w.file_sets&.map { |fs| fs.label.end_with?(".pdf") }.any?

      # does this work have any children?
      # For now we assume that if there are child works, it is correct.
      # note: if we were to calculate the expected number of pages on each pdf,
      #       we could also process in cases where we have some but not all of the
      #       child works. For now we only process if there are no child works.
      #       Single works can still be reprocessed by submitting with an id.
      next unless w.child_works.none?

      do_cleanup!(w)
    end
  rescue StandardError
    logger.info("🚫 Unable to process #{@context}")
  end

  def do_cleanup!(work)
    @counter += 1
    logger.info("✅ Enqueuing re-import for #{@context}.")

    ReloadSinglePdfJob.perform_later(work: work)
  rescue StandardError => e
    logger.error("😈😈😈 Error: #{e.message} for #{@context}")
    raise e
  end
end
