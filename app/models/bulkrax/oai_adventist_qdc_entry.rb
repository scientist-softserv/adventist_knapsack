# frozen_string_literal: true

module Bulkrax
  class OaiAdventistQdcEntry < OaiQualifiedDcEntry
    # OVERRIDE Bulkrax::Entry#field_to to skip over the user provided "identifier" field in the
    # record's metadata.  That field contains a previous catalog's identifier.  Per conversations
    # with the client, we can skip this field.
    #
    # @see https://assaydepot.slack.com/archives/C0313NJV9PE/p1676478120061659?thread_ts=1676476112.956259&cid=C0313NJV9PE
    def field_to(field)
      return [] if field == "identifier"
      super(field)
    end

    # Note: We're overriding the setting of the thumbnail_url as per prior implementations in
    # Adventist's code-base.
    def add_thumbnail_url
      true
    end

    # @see https://github.com/scientist-softserv/adventist-dl/issues/281
    def collections_created?
      true
    end

    # @see https://github.com/scientist-softserv/adventist-dl/issues/281
    def find_collection_ids
      self.collection_ids = []
    end
  end
end
