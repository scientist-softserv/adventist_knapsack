#!/usr/bin/env ruby

require 'csv'
require 'httparty'
require 'aws-sdk-sqs'

SERVERLESS_ALTO_DLQ = ENV.fetch('SERVERLESS_ALTO_DLQ')
SERVERLESS_COPY_DLQ = ENV.fetch('SERVERLESS_COPY_DLQ')
SERVERLESS_OCR_DLQ = ENV.fetch('SERVERLESS_OCR_DLQ')
SERVERLESS_PLAIN_TEXT_DLQ = ENV.fetch('SERVERLESS_PLAIN_TEXT_DLQ')
SERVERLESS_OCR_THUMB_DLQ = ENV.fetch('SERVERLESS_OCR_THUMB_DLQ')
SERVERLESS_THUMBNAIL_DLQ = ENV.fetch('SERVERLESS_THUMBNAIL_DLQ')
SERVERLESS_WORD_DLQ = ENV.fetch('SERVERLESS_WORD_DLQ')

##
# This class is responsible for looping through a CSV and enqueing those records based on some
# business logic.
#
# @example
#   ErrorsFromSpacestone.new.insert_into_spacestone
class ErrorsFromSpacestone
  CSV_NAME = 'csv_from_oai.csv'
  def initialize
    @client = Aws::SQS::Client.new(region: 'us-east-1')
    @serverless_alto_dlq = ENV.fetch('SERVERLESS_ALTO_DLQ')
    @serverless_copy_dlq = ENV.fetch('SERVERLESS_COPY_DLQ')
    @serverless_ocr_dlq = ENV.fetch('SERVERLESS_OCR_DLQ')
    @serverless_plain_text_dlq = ENV.fetch('SERVERLESS_PLAIN_TEXT_DLQ')
    @serverless_ocr_thumb_dlq = ENV.fetch('SERVERLESS_OCR_THUMB_DLQ')
    @serverless_thumbnail_dlq = ENV.fetch('SERVERLESS_THUMBNAIL_DLQ')
    @serverless_word_dlq = ENV.fetch('SERVERLESS_WORD_DLQ')
  end
  attr_reader :client

  def download_errors
    %w[alto copy ocr plain_text ocr_thumb thumbnail word].each do |type|
      queue_url = self.instance_variable_get("@serverless_#{type}_dlq")

      resp = client.get_queue_attributes({
        queue_url: queue_url,
        attribute_names: ['ApproximateNumberOfMessages'],
      })
      count = resp.attributes['ApproximateNumberOfMessages'].to_i
      ((count / 10) + 2).times do
        response = client.receive_message(
          queue_url: queue_url,
          max_number_of_messages: 10
        )
        File.open("#{type}-dlg.json", 'a') do |file|
          response.messages.each do |message|
            file.puts(message.body)
          end
        end
      end
    end
  end
end

loader = ErrorsFromSpacestone.new.download_errors
