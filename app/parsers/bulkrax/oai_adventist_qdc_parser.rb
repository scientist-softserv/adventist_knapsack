# frozen_string_literal: true

module Bulkrax
  # **Assumption 1 regarding Adventist's OAI feed:** The works, collections, and file sets are declared
  # at the OAI record level data.
  #
  # **Assumption 2 regarding Adventist's OAI feed:** The operator will run the OAI's set(s) that
  # contain collections before those collections are declared/referenced in other works.  Due to the
  # asynchronous nature of the entry jobs this means that an importer job (or jobs) should be run
  # for sets that define the collections; then the importer job(s) should be run for works and file
  # sets.  If in the future we find that there is a mixture of collection, work, and file set
  # objects with an OAI feed we might want to consider parameterizing the importer to say
  # "collections" or not "collections" and then add conditionals accordingly.
  #
  # From these assumptions we need to be mindful that our collection creation is different than
  # other OAI collection creations.
  class OaiAdventistQdcParser < OaiQualifiedDcParser
    def entry_class
      Bulkrax::OaiAdventistQdcEntry
    end

    alias work_entry_class entry_class

    def collection_entry_class
      Bulkrax::OaiAdventistSetEntry
    end

    def file_set_entry_class
      RdfFileSetEntry
    end

    # Setting both #count_towards_limit and #counters as part of initialization so that regardless
    # of how we create the objects (e.g. either sequentially calling #create_collections,
    # #create_file_sets, #create_works, #create_relationships OR calling #create_objects) we
    # adequately handle the various counts.
    def initialize(*args, &block)
      super
      @count_towards_limit = 0
      @counters = { file_set: 0, collection: 0, work: 0 }
      @offset = importer.parser_fields['offset'].to_i
    end

    ##
    # Skip over records that are
    attr_reader :offset

    # @see #initialize
    #
    # Because of the assumptions outlined in the class declaration, we are processing a mixture of
    # file_set, collection, and work types.  Thus we can't rely on the index as we have in other
    # parser implementations.  Instead we'll
    attr_accessor :counters

    # @see #initialize
    attr_accessor :count_towards_limit
    private :counters, :counters=, :count_towards_limit, :count_towards_limit=

    # @note Included for previous API compatibility.
    def create_collections
      create_objects(['collection'])
    end

    # @note Included for previous API compatibility.
    def create_file_sets
      create_objects(['file_set'])
    end

    # @note Included for previous API compatibility.
    def create_works
      create_objects(['work'])
    end

    # @note Included for previous API compatibility.
    def create_relationships
      create_objects(['relationship'])
    end

    # @note With Bulkrax v4.4.0 we leverage the #create_objects method; in part because we want to
    #       better handle limits.
    # @param types_array [Array<String>]
    def create_objects(types_array = nil)
      types_array ||= Bulkrax::Importer::DEFAULT_OBJECT_TYPES
      types_array.each do |type|
        send("dispatch_creating_of_#{type}_objects")
      end
      importer.record_status
    end

    def dispatch_creating_of_relationship_objects
      return true if @relationship_was_dispatched

      ScheduleRelationshipsJob.set(wait: 5.minutes).perform_later(importer_id: importerexporter.id)
      @relationship_was_dispatched = true
    end

    # In the adventist parser, we process the full records (e.g. OAI's listRecords).  To
    # understand why do this, we must contrast this with the Bulkrax OAI parser.
    #
    # In the Bulkrax OIA parser we process the identifiers (e.g. OAI's listIdentifiers).  The
    # limitation on the identifiers is that we can't "sniff" what type of object it is (e.g. work,
    # collection, or file_set).
    #
    # Due to the assumptions outlined in the class definition, namely that collections, works, and
    # file_sets are defined within the record's metadata (e.g. the XML node work_type), we process
    # the listRecords so we can "sniff" out the appropriate entity type.
    #
    # @return [Integer] the number of objects we processed
    def dispatch_creating_of_work_objects
      return true if @repository_objects_were_dispatched

      # The records.full call ensures that we leverage the pagination/resumption mechanisms of OAI
      # (via Ruby's OAI gem).  We choose #each so that we only load in memory each page's records.
      # Were we to choose #map, we would load all records into memory.
      records.full.each_with_index do |record, index|
        ##
        # Start processing after we skipped the offset number of records.  Hello space for off by
        # one errors.
        #
        # This reads much better if the if block.
        # rubocop:disable Style/Next
        if index >= offset
          break if limit_reached?(limit, count_towards_limit)
          handle_creation_of(record: record, index: index)
          self.count_towards_limit += 1
        end
        # rubocop:enable Style/Next
      end

      @repository_objects_were_dispatched = true
    end

    # @see the note associated with the #dispatch_creating_of_work_objects method
    alias dispatch_creating_of_collection_objects dispatch_creating_of_work_objects

    # @see the note associated with the #dispatch_creating_of_work_objects method
    alias dispatch_creating_of_file_set_objects dispatch_creating_of_work_objects

    # @param record [Oai::Record]
    # @param index [Integer] the index/position of the Oai::Record in the OAI feed.
    def handle_creation_of(record:, index:)
      return false unless record_has_source_identifier(record, index)

      # Given the specificity and standards of an Oai::Record; I'm using this as the identifier.
      # I'm not looking to the mapping file.
      identifier = record.header.identifier
      seen[identifier] = true

      # We need the type for two considerations:
      #
      # - What's the entry class
      # - What's the counter to increment
      entry_class_type = entry_class_type_for(record: record)

      entry_class = send("#{entry_class_type}_entry_class")

      # We want to find or create the entry based on non-volatile information.  Then we want to
      # capture the raw metadata for the record; capturing the raw metadata helps in debugging the
      # object.
      new_entry = entry_class.where(importerexporter: importerexporter, identifier: identifier).first_or_create!
      new_entry.update(raw_metadata: { record_level_xml: record._source.to_s })

      # Note the parameters of the delete job and the import jobs are different.  One assumes an
      # object the other assumes ids.
      if record.deleted?
        "bulkrax/delete_#{entry_class_type}_job"
          .classify
          .constantize
          .send(perform_method, new_entry, importerexporter.current_run)
      else
        "bulkrax/import_#{entry_class_type}_job"
          .classify
          .constantize
          .send(perform_method, new_entry.id, importerexporter.current_run.id)
      end

      increment_counters(index, entry_class_type => counters.fetch(entry_class_type))

      # Why am I incrementing the counters after we call increment_counters?  Because in
      # {#increment_counters} implementation we add 1 to the counter value.  Why do we add 1?
      # Because in other implementations that call {#increment_counters} they use a positional index
      # of the object in the array (e.g. we use #each_with_index and the yielded index as the
      # counter).
      #
      # And we can't use the positional index because the we have a heterogenious set of
      # entry_class_types tracked on that same index.
      counters[entry_class_type] += 1
    end

    # @param record [Oai::Record]
    # @param index [Integer] the positional index of the record in the OAI feed.
    # @return [TrueClass] when we have an identifier.
    # @return [FalseClass] when we do not have an identifier.
    #
    # @note This method deviates from Bulkrax's implemtation in that it's unclear how the OAI object
    #       would not have an identifier.
    #
    # @see Bulkrax::ApplicationParser#record_has_source_identifier
    def record_has_source_identifier(record, index)
      # Given the specificity and standards of an Oai::Record; I'm using this as the identifier.
      # I'm not looking to the mapping file.
      return true if record.header.identifier.present?

      invalid_record("Missing #{source_identifier} at index #{index} with source #{record._source}\n")
      false
    end

    # @param record [Oai::Record]
    # @return [Symbol] either :collection, :file_set, or :work
    def entry_class_type_for(record:)
      entry_class_type = nil
      model_field_mappings.each do |model_mapping|
        record_entry_class_type = record.metadata.find("//#{model_mapping}").first&.content || ""
        if record_entry_class_type.casecmp('collection').zero?
          entry_class_type = :collection
          break
        elsif record_entry_class_type.casecmp('fileset').zero?
          entry_class_type = :file_set
          break
        elsif record_entry_class_type.casecmp('file_set').zero?
          entry_class_type = :file_set
          break
        end
      end
      entry_class_type || :work
    end
  end
end
