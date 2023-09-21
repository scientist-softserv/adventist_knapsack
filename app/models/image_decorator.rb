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
end

Image.prepend ImageDecorator
# This must come after the properties because it finalizes the metadata
# schema (by adding accepts_nested_attributes)
Image.include SlugMetadata
Image.include AdventistMetadata
