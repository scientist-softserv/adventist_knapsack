# frozen_string_literal: true

module CollectionIndexerDecorator
  # Add any custom indexing into here. Method must exist, but can be empty.
  def do_local_indexing(solr_doc); end
end

CollectionIndexer.prepend(CollectionIndexerDecorator)
CollectionIndexer.include(::DogBiscuitsHelper)
