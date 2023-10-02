# frozen_string_literal: true

# TODO: look at this in the context of new BULKRAX version
# OVERRIDE Bulkrax 1.0.2 to override default_thumbnail

module Bulkrax
  module ApplicationMatcherDecorator
    # OVERRIDE Bulkrax 1.0.2 to override default_thumbnail
    def process_parse
      # New parse methods will need to be added here
      parsed_fields = ['remote_files',
                       'language',
                       'subject',
                       'types',
                       'model',
                       'resource_type',
                       'format_original',
                       'thumbnail_url']
      # This accounts for prefixed matchers
      parser = parsed_fields.find { |field| to&.include? field }

      if @result.is_a?(Array) && parsed && respond_to?("parse_#{parser}")
        @result.each_with_index do |res, index|
          @result[index] = send("parse_#{parser}", res.strip)
        end
        @result.delete(nil)
      elsif parsed && respond_to?("parse_#{parser}")
        @result = send("parse_#{parser}", @result)
      end
    end

    # OVERRIDE Bulkrax 1.0.2 to override default_thumbnail
    def parse_thumbnail_url(src)
      return if src.blank?
      src.strip!
      name = Bulkrax::Importer.safe_uri_filename(src)
      { url: src, file_name: name, default_thumbnail: "true" }
    end
  end
end

Bulkrax::ApplicationMatcher.prepend(Bulkrax::ApplicationMatcherDecorator)
