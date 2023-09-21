# frozen_string_literal: true

module Bulkrax
  class OaiAdventistSetEntry < OaiSetEntry
    def build_metadata
      self.parsed_metadata = {}
      # rubocop:disable Style/RedundantSelf
      #
      # Yes I could favor `parsed_metadata[work_identifier]` however in the above line, we use
      # `self.` And so as to maintain the visual cues of "these are the same symbols" I'm choosing
      # to disable the RedundantSelf cop for this method.
      self.parsed_metadata[work_identifier] = [record.header.identifier]
      self.raw_metadata = { record_level_xml: record._source.to_s }

      record.metadata.children.each do |child|
        child.children.each do |node|
          add_metadata(node.name, node.content)
        end
      end

      # Note: as of the time of writing this comment, the Bulkrax::OaiSetEntry does not handle
      # metadata nor does it do anything with visibility, rights statements, or admin sets.  This is
      # added as an override that I'd love to see "removed"
      add_visibility
      add_rights_statement

      # see app/models/concerns/bulkrax/has_local_processing.rb
      add_local

      self.parsed_metadata
      # rubocop:enable Style/RedundantSelf
    end
  end
end
