# frozen_string_literal: true

module Bulkrax
  module HasLocalProcessing
    # This method is called during build_metadata
    # add any special processing here, for example to reset a metadata property
    # to add a custom property from outside of the import data
    def add_local
      # Because of the DerivativeRodeo and SpaceStone, we may already have the appropriate thumbnail
      # ready to attach to the file_sets.  If we proceed with using the thumbnail_url, we end up
      # attaching that thumbnail as it's own file_set.  Which is likely non-desirous behavior.
      #
      if respond_to?(:each_candidate_metadata_node)
        each_candidate_metadata_node do |node|
          raw_metadata['thumbnail_url'] = node.content if node.name == 'thumbnail_url'
        end
      end

      if parser.parser_fields['skip_thumbnail_url'] == "1"
        parsed_metadata.delete('thumbnail_url')
      elsif raw_metadata['thumbnail_url']
        parsed_metadata['thumbnail_url'] = parse_thumbnail_url(raw_metadata['thumbnail_url'])
      end
      self
    end

    def parse_thumbnail_url(src)
      return if src.blank?
      src.strip!
      name = Bulkrax::Importer.safe_uri_filename(src)
      { url: src, file_name: name, override_default_thumbnail: "true" }
    end
  end
end
