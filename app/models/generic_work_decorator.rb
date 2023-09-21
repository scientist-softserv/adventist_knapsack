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

  included do
  validates :title, presence: { message: 'Your work must have a title.' }

  self.indexer = WorkIndexer
  self.human_readable_type = 'Work'

  prepend OrderAlready.for(:creator)
  end
end

GenericWork.prepend(GenericWorkDecorator)
