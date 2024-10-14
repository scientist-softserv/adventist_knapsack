# frozen_string_literal: true

ImageResourceIndexer.include Hyrax::Indexer(:slug_metadata)
ImageResourceIndexer.include(SlugIndexing)
ImageResourceIndexer.include(SortedDateIndexer)

