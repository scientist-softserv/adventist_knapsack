# frozen_string_literal: true

module GenericWorkDecorator
  extend ActiveSupport::Concern

  include VideoEmbedViewer
  include ::Hyrax::WorkBehavior
  include DogBiscuits::Abstract
  include DogBiscuits::BibliographicCitation
  include DogBiscuits::DateIssued
  include DogBiscuits::Geo
  include DogBiscuits::PartOf
  include DogBiscuits::PlaceOntistMetadata
  include SlugBug
  include IiifPrint.model_configuration(
    pdf_split_child_model: self,
    pdf_splitter_service: IiifPrint::SplitPdfs::AdventistPagesToJpgsSplitter,
    derivative_service_plugins: [
      IiifPrint::TextExtractionDerivativeService
    ]
  )
end

GenericWork.prepend(GenericWorkDecorator)

# This must come after the properties because it finalizes the metadata
# schema (by adding accepts_nested_attributes)
GenericWork.include SlugMetadata
GenericWork.include AdventistMetadata
