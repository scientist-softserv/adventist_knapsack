# frozen_string_literal: true

# Generated via
#  `rails generate dog_biscuits:work Dataset`
class DatasetIndexer < WorkIndexer
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

  # NB. include 'contributor' here if it is used in the form
  def contributors_to_index
    ['funder']
  end

  # Force the type of certain indexed fields in solr
  # (inspired by
  #   http://projecthydra.github.io/training/deeper_into_hydra/#slide-63,
  #   http://projecthydra.github.io/training/deeper_into_hydra/#slide-64
  #   and discussed at
  #   https://groups.google.com/forum/#!topic/hydra-tech/rRsBwdvh5dE)
  # This is to overcome limitations with solrizer and
  #   "index.as :stored_sortable" always defaulting to string rather
  #   than text type (solr sorting on string fields is case-sensitive,
  #   on text fields it's case-insensitive)
  def do_local_indexing(solr_doc)
    solr_doc['dc_access_rights_tesi'] = object.dc_access_rights.collect { |x| x }
  end

  # Fetch remote labels for based_near. Copied from Hyrax::IndexesLinkedMetadata
  def rdf_service
    Hyrax::DeepIndexingService
  end
end
