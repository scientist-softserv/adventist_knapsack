# frozen_string_literal: true

# IndexPlainTextFilesJob  is  responsible  for adding  each  plain  text
# files's content (e.g. the text)  to the file_set's extracted text.  In
# doing so, folks can then search for the text of the given file.
class IndexPlainTextFilesJob < ApplicationJob
  non_tenant_job

  # IndexPlainTextFilesJob  is  responsible  for adding  a single  plain  text
  # files's content (e.g. the text)  to the file_set's extracted text.
  #
  # @see Adventist::TextFileTextExtractionService
  # @see https://docs.ruby-lang.org/en/2.7.0/String.html#method-i-encode
  class One < ApplicationJob
    # @param file_set_id [String]
    # rubocop:disable Metrics/BlockLength
    def perform(account, file_set_id, time_to_live = 3, logger: IndexPlainTextFilesJob.default_logger)
      account.switch do
        begin
          file_set = FileSet.find(file_set_id)

          if file_set.extracted_text.present?
            logger.warn("#{self.class}: FileSet ID=\"#{file_set.id}\" (in #{account.cname}) has extracted text; "\
                        "moving on.")
            return true
          end

          file = file_set.original_file

          unless file
            logger.error("#{self.class}: FileSet ID=\"#{file_set_id}\" expected to have an original_file; " \
                         "however it was missing.")
            return false
          end

          Adventist::TextFileTextExtractionService.assign_extracted_text(
            file_set: file_set,
            text: file.content,
            original_file_name: Array(file.file_name).first
          )
          logger.info("#{self.class}: FileSet ID=\"#{file_set_id}\" text extracted from plain text file.")
          return true
        rescue StandardError => e
          if time_to_live.positive?
            # It's possible we can recover from this, so we'll give it another go.
            logger.warn("#{self.class}: FileSet ID=\"#{file_set_id}\" error for #{self.class}: #{e}.  " \
                        "Retries remaining #{time_to_live - 1}.")
            One.perform_later(account, file_set_id, time_to_live - 1)
          else
            logger.error("#{self.class}: FileSet ID=\"#{file_set_id}\" error for #{self.class}: #{e}.  " \
                         "No retries remaining.  Backtrace: #{e.backtrace}")
          end
          return false
        end
      end
    end
    # rubocop:enable Metrics/BlockLength
  end

  # @param account [Account]
  def perform(account, logger: self.class.default_logger)
    logger.warn("#{self.class}: Begin processing file sets for #{account.cname}")
    account.switch do
      # rubocop:disable Style/BracesAroundHashParameters
      #
      # Because there are two hashes as parameters, I want to be explicit about which one is which.
      FileSet.search_in_batches({ mime_type_ssi: 'text/plain' }, { batch_size: 25 }) do |group|
        # rubocop:enable Style/BracesAroundHashParameters
        group.each do |file_set|
          logger.warn("#{self.class}: FileSet ID=\"#{file_set['id']}\" (in #{account.cname}) enquing to extract text.")
          One.perform_later(account, file_set['id'])
        end
      end
    end
  end

  # Why the indirection?  As I was exploring which logger to use, I was rotating between:
  # Rails.logger, Sidekiq.logger, and Logger.new.  All of which is to say this indirection helped me
  # not have to change too many places elsewhere in the code.
  ##
  # @api private
  # @return [Logger]
  def self.default_logger
    if defined?(Rails)
      Rails.logger
    else
      Logger.new(STDOUT)
    end
  end
end
