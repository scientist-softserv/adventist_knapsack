# frozen_string_literal: true

GenericWorkResourceIndexer.include Hyrax::Indexer(:slug_metadata)
GenericWorkResourceIndexer.include(SlugIndexing)
