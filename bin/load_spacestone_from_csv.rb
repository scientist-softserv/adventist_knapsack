#!/usr/bin/env ruby

require 'csv'
require 'httparty'
require 'aws-sdk-sqs'

SERVERLESS_COPY_URL = ENV.fetch('SERVERLESS_COPY_URL')
SERVERLESS_S3_URL = ENV.fetch('SERVERLESS_S3_URL')
SERVERLESS_TEMPLATE = ENV.fetch('SERVERLESS_TEMPLATE')
SERVERLESS_SPLIT_SQS_URL = ENV.fetch('SERVERLESS_SPLIT_SQS_URL')
SERVERLESS_OCR_SQS_URL = ENV.fetch('SERVERLESS_OCR_SQS_URL')
SERVERLESS_THUMBNAIL_SQS_URL = ENV.fetch('SERVERLESS_THUMBNAIL_SQS_URL')
SERVERLESS_COPY_SQS_URL = ENV.fetch('SERVERLESS_COPY_SQS_URL')
SERVERLESS_BATCH_SIZE = ENV.fetch('SERVERLESS_BATCH_SIZE', 10).to_i

##
# This class is responsible for looping through a CSV and enqueing those records based on some
# business logic.
#
# @example
#   LoadSpaceStoneFromCsv.new.insert_into_spacestone
class LoadSpaceStoneFromCsv
  CSV_NAME = 'csv_from_oai.csv'
  def initialize
    @csv = CSV.read(CSV_NAME, headers: true)
    @client = Aws::SQS::Client.new(region: 'us-west-2')
  end
  attr_reader :csv, :client

  def insert_into_spacestone
    csv.each do |row|
      puts row.inspect
      needs_thumbnail = !has_thumbnail?(row)
      copy_original(row, needs_thumbnail)
      copy_access(row, needs_thumbnail)
    end
    # When we are done processing each row, we need to handle whatever remains in the queue.
    # Without this line, we could have CSV rows (or partial rows) that we buffered into the queue
    # but never submitted.
    send_remainder_of_queue!
  end

  ##
  # For an original file:
  #
  # - Copy the original file to the SpaceStone location
  # - When it is a PDF, enqueue splitting it
  # - When it does not have a thumbnail, enqueue creating a thumbnail
  #
  # @param row [CSV::Row]
  # @param needs_thumbnail [Boolean] when true we will need to enqueue a thumbnail generation job.
  def copy_original(row, needs_thumbnail)
    original_extension = File.extname(row['original'])
    jobs = [original_destination(row)]

    # TODO: In the case of PDF, Split; in the case of images, OCR.  In all cases thumbnail.
    if original_extension == '.pdf'
      jobs << enqueue_destination(row, key: 'original', url: SERVERLESS_SPLIT_SQS_URL)
    else
      jobs << enqueue_destination(row, key: 'original', url: SERVERLESS_OCR_SQS_URL)
    end
    if needs_thumbnail
      jobs << enqueue_destination(row, key: 'original', url: SERVERLESS_THUMBNAIL_SQS_URL)
    end

    post_to_sqs_copy({ row['original'] => jobs })
  end

  def copy_access(row, needs_thumbnail)
    return if row['reader'].to_s.strip.empty?
    original_extension = File.extname(row['original'])
    return unless original_extension == '.pdf'

    jobs = [original_destination(row, key: 'reader')]

    if needs_thumbnail
      jobs << enqueue_destination(row, key: 'reader', url: SERVERLESS_THUMBNAIL_SQS_URL)
    end

    post_to_sqs_copy({ row['reader'] => jobs })
  end

  def thumbnail_destination(row, key: 'original')
    # We might have multiple periods in the filename, remove the extension.
    thumbnail_name = File.basename(row[key]).sub(/\.[^\.]*\z/, ".thumbnail.jpeg")
    "#{SERVERLESS_S3_URL}#{row['aark_id']}/#{thumbnail_name}"
  end

  def enqueue_destination(row, url:, key: 'original')
    basename = File.basename(row[key])
    "#{url}#{row['aark_id']}/#{basename}?template=#{SERVERLESS_S3_URL}#{SERVERLESS_TEMPLATE}"
  end

  def original_destination(row, key: 'original')
    "#{SERVERLESS_S3_URL}#{row['aark_id']}/#{File.basename(row[key])}"
  end

  def has_thumbnail?(row)
    return false if row['thumbnail'].to_s.strip.empty?
    return false unless row['thumbnail'].to_s.match(/^https?/)

    # Regardless of the original's type, if we have a thumbnail copy it.
    post_to_sqs_copy({ row['thumbnail'] => [thumbnail_destination(row)] })

    # We'll only repurpose the thumbnail if the reader is a PDF.
    if !row['reader'].to_s.strip.empty? && row['reader'].end_with?('.pdf')
      post_to_sqs_copy({ row['thumbnail'] => thumbnail_destination(row, key: 'reader') })
    end

    true
  end

  ##
  # SQS related methods
  def post_to_sqs_copy(workload)
    @queue ||= []
    @queue << { id: SecureRandom.uuid, message_body: workload.to_json }
    if (@queue.size % SERVERLESS_BATCH_SIZE) == 0
      send_batch(@queue)
      @queue = []
    end
  end

  def send_remainder_of_queue!
    return unless defined?(@queue)
    return if @queue.empty?
    send_batch(@queue)
  end

  def send_batch(batch)
    puts "\t#{SERVERLESS_COPY_SQS_URL}\n\t#{batch.inspect}"
    client.send_message_batch({
      queue_url: SERVERLESS_COPY_SQS_URL,
      entries: batch
    }) unless ENV['DRY_RUN']
  end
end

loader = LoadSpaceStoneFromCsv.new.insert_into_spacestone
