# frozen_string_literal: true

module ImageDecorator
  extend ActiveSupport::Concern
  include ::Hyrax::WorkBehavior
  include SlugBug
  include DogBiscuits::Abstract
  include DogBiscuits::BibliographicCitation
  include DogBiscuits::DateIssued
  include DogBiscuits::Geo
  include DogBiscuits::PartOf
  include DogBiscuits::PlaceOfPublication
  include IiifPrint.model_configuration(
    pdf_split_child_model: self,
    pdf_splitter_service: IiifPrint::SplitPdfs::AdventistPagesToJpgsSplitter,
    derivative_service_plugins: [
      IiifPrint::TextExtractionDerivativeService
    ]
  )

  included do
    property :extent, predicate: ::RDF::Vocab::DC.extent, multiple: true do |index|
      index.as :stored_searchable
    end

    # This must come after the properties because it finalizes the metadata
    # schema (by adding accepts_nested_attributes)
    include SlugMetadata
    include AdventistMetadata

    self.indexer = WorkIndexer
    # Change this to restrict which works can be added as a child.
    # self.valid_child_concerns = []
    validates :title, presence: { message: 'Your work must have a title.' }

    self.human_readable_type = 'Image'

    prepend OrderAlready.for(:creator)
  end
end
