# frozen_string_literal: true

# Generated via
#  `rails generate hyrax:work_resource DatasetResource`
class DatasetResourceIndexer < Hyrax::ValkyrieWorkIndexer
  include Hyrax::Indexer(:basic_metadata)
  include Hyrax::Indexer(:adl_metadata)
  include Hyrax::Indexer(:dataset_resource)
  include Hyrax::Indexer(:with_pdf_viewer)
  include Hyrax::Indexer(:with_video_embed)
  include Hyrax::Indexer(:bulkrax_metadata)
  include Hyrax::Indexer(:slug_metadata)
  include HykuIndexing
  include SlugIndexing
  include SortedDateIndexer
  # Uncomment this block if you want to add custom indexing behavior:
  #  def to_solr
  #    super.tap do |index_document|
  #      index_document[:my_field_tesim]   = resource.my_field.map(&:to_s)
  #      index_document[:other_field_ssim] = resource.other_field
  #    end
  #  end
end
