# frozen_string_literal: true

# Generated via
#  `rails generate dog_biscuits:work JournalArticle`
class JournalArticle < DogBiscuits::JournalArticle
  include ::Hyrax::WorkBehavior
  include SlugBug
  include DogBiscuits::BibliographicCitation
  include DogBiscuits::DateIssued
  include DogBiscuits::Geo
  include DogBiscuits::PlaceOfPublication
  include DogBiscuits::RemoteUrl

  self.indexer = ::JournalArticleIndexer
  # Change this to restrict which works can be added as a child.
  # self.valid_child_concerns = []
  validates :title, presence: { message: 'Your work must have a title.' }

  # This must be included at the end, because it finalizes the metadata
  # schema (by adding accepts_nested_attributes)
  include ::Hyrax::BasicMetadata
  include SlugMetadata
  include DogBiscuits::JournalArticleMetadata
  before_save :combine_dates

  prepend OrderAlready.for(:creator)
  include IiifPrint.model_configuration(
    pdf_split_child_model: self,
    pdf_splitter_service: IiifPrint::SplitPdfs::AdventistPagesToJpgsSplitter,
    derivative_service_plugins: [
      IiifPrint::TextExtractionDerivativeService
    ]
  )

  include AdventistMetadata
end

JournalArticle.instance_variable_set(:@generated_resource_class, nil)
JournalArticle.resource_class

JournalArticle.resource_class.send(:include, AdventistMetadata)
JournalArticle.resource_class.send(:include, SlugBug)
JournalArticle.resource_class.send(:include, DogBiscuits::BibliographicCitation)
JournalArticle.resource_class.send(:include, DogBiscuits::DateIssued)
JournalArticle.resource_class.send(:include, DogBiscuits::Geo)
JournalArticle.resource_class.send(:include, DogBiscuits::PlaceOfPublication)
JournalArticle.resource_class.send(:include, DogBiscuits::RemoteUrl)
