#!/usr/bin/env ruby

require 'csv'
require 'oai'
require 'byebug'
require_relative "../lib/oai/client_decorator"

class CsvFromOai
  attr_accessor :email

  def initialize(email:)
    @email = email
  end

  def client
    # OAI client setup
    @client ||= OAI::Client.new(
      "http://oai.adventistdigitallibrary.org/OAI-script",
      headers: { from: email },
      parser: 'libxml'
    )
  end

  def sets
    @sets ||= [
      "adl:thesis",
      "adl:periodical",
      "adl:issue",
      "adl:article",
      "adl:image",
      "adl:book",
      "adl:other"
    ]
  end

  def opts
    @opts ||= {
      metadata_prefix: "oai_adl"
    }
  end

  def urls_for(record, metadata_label)
    urls = record.metadata.first.find(metadata_label) || [ ]
    urls.map(&:content).map { |url| url.split(';') }.flatten
  end

  def url_is_original?
    ->(u) {
      u.end_with?('.ARCHIVAL.pdf') ||
        (u.match(/\.OBJ\./) && !u.match(/\.X\d+\./))
    }
  end

  def url_is_text?
    ->(u) { u.end_with?('.RAW.txt') }
  end

  def url_is_reader?
    ->(u) {
      (!u.end_with?('.ARCHIVAL.pdf') && u.end_with?('.pdf')) ||
        u.match(/\.X\d+/)
    }
  end

  def process_related_urls(urls)
    original = text = reader = nil
    other_files = []
    urls.each do |url|
      case url
      when url_is_original?
        original = url
      when url_is_text?
        text = url
      when url_is_reader?
        reader = url
      else
        other_files << url
      end
    end
    { 'original' => original, 'text' => text, 'reader' => reader, 'other_files' => other_files }
  end


  def csv_headers
    @csv_headers ||= ["oai_set","aark_id", "original", "text", "reader", "thumbnail", "other_files"]
  end

  def build_csv
    CSV.open('csv_from_oai.csv',
      'wb',
      write_headers: true,
      headers: csv_headers
    ) do |csv|
      # Write the headers to the CSV file
      sets.each do |set|
        records = client.list_records(opts.merge(set: set))
        # For the full set of records.
        record_set = ENV.fetch('FULL', nil) ? records.full : records
        record_set.each_with_index do |r, i|
          puts "== Record #{i} of Set #{set}"
          # For the first 25 records, comment out previous line and comment in the following line.
          # records.each_with_index do |r|
          row = { 'oai_set' => set }
          row['aark_id'] = r.header.identifier
          thumbnail_urls = urls_for(r, 'thumbnail_url')
          related_urls = urls_for(r, 'related_url')

          row.merge!(process_related_urls(related_urls))
          row['thumbnail'] = thumbnail_urls.first
          csv << csv_headers.map { |h| row[h] }.flatten
        end
      end
    end
  end

  def build_csv_resume(page: )
    set = "adl:issue"

    CSV.open("csv_from_oai#{page}.csv",
      'wb',
      write_headers: true,
      headers: csv_headers
    ) do |csv|
      # Write the headers to the CSV file
      records = client.list_records(opts.merge(set: set, resumption_token: "adl:issue|#{page}"))
      # For the full set of records.
      record_set = records.full
      record_set.each_with_index do |r, i|
        puts "== Record #{i} of Set #{set} - Page #{record_set.instance_variable_get("@response").resumption_token}"
        # For the first 25 records, comment out previous line and comment in the following line.
        # records.each_with_index do |r|
        row = { 'oai_set' => set }
        row['aark_id'] = r.header.identifier
        thumbnail_urls = urls_for(r, 'thumbnail_url')
        related_urls = urls_for(r, 'related_url')

        row.merge!(process_related_urls(related_urls))
        row['thumbnail'] = thumbnail_urls.first
        csv << csv_headers.map { |h| row[h] }.flatten
      end
    end
  end

end

email = ENV.fetch('CSV_EMAIL', nil)
unless email
  email = ARGV.detect { |arg| arg.match(/^--email/) }
  email = email.gsub('--email=', '').strip
end

page = ARGV.detect { |arg| arg.match(/^--page/) }
if page
  page = page.gsub('--page=', '').strip
  CsvFromOai.new(email: email).build_csv_resume(page: page)
else
  CsvFromOai.new(email: email).build_csv
end
