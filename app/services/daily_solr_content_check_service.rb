# frozen_string_literal: true

# The purpose of this class is to provide insight into what objects have made it into Solr.
class DailySolrContentCheckService
  # While the original ticket asked for aark_id_tesim, id, and timestamp, it is the author's opinion
  # that having the Fedora ID might be useful for debugging and triage.
  FIELDS = %w[aark_id_tesim id fedora_id_ssi timestamp].freeze
  QUERY = "aark_id_tesim:[* TO *]"

  # @param buffer [#puts] where we "puts" the entries we find.
  # @param delimiter [#to_s] the field separator for entries
  # @param logger [#info] where we log informational tasks
  # @param fields [Array<String>]
  # @param query [String,Hash] passed as query to ActiveFedora::Base.search_in_batches
  #
  # @note Why all the logging?  One concern is how this query might affect performance.  And with
  #       each logged moment we have a timestamp with which we can compare the system resource
  #       utilization.
  def self.call(buffer: STDOUT, delimiter: "\t", logger: Rails.logger, fields: FIELDS, query: QUERY)
    logger.info "Starting #{self}.call"

    buffer.puts "cname#{delimiter}#{fields.join(delimiter)}"
    Account.all.each do |account|
      account.switch do
        logger.info "Begin #{self}.call loop for #{account.cname}"
        index = 0
        ActiveFedora::Base.search_in_batches(query, fl: fields, batch_size: 1_000) do |group|
          logger.info "Handling #{self}.call with #{account.cname} batch index #{index}"
          index += 1
          group.each do |item|
            values = fields.map { |field| item.fetch(field, '') }
            buffer.puts "#{account.cname}#{delimiter}#{values.join(delimiter)}"
          end
        end
        logger.info "End #{self}.call loop for #{account.cname}"
      end
    end
    logger.info "Finishing #{self}.call"
  end
end
