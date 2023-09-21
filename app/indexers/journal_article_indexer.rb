# frozen_string_literal: true

# Generated via
#  `rails generate dog_biscuits:work JournalArticle`
class JournalArticleIndexer < WorkIndexer
  include DogBiscuits::IndexesCommon
  # This indexes the default metadata. You can remove it if you want to
  # provide your own metadata and indexing.
  # include Hyrax::IndexesBasicMetadata

  # Fetch remote labels for based_near. You can remove this if you don't want
  # this behavior
  # include Hyrax::IndexesLinkedMetadata

  # Uncomment this block if you want to add custom indexing behavior:
  # def generate_solr_document
  #  super.tap do |solr_doc|
  #    solr_doc['my_custom_field_ssim'] = object.my_custom_property
  #  end
  # end

  # Add any properties to ensure they are 'mixed in' with the *_labels field in solr
  def contributors_to_index
    ['funder']
  end

  # Add any custom indexing into here. Method must exist, but can be empty.
  def do_local_indexing(solr_doc); end

  # Fetch remote labels for based_near. Copied from Hyrax::IndexesLinkedMetadata
  def rdf_service
    Hyrax::DeepIndexingService
  end
end
