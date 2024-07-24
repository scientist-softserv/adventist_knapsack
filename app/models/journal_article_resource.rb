# frozen_string_literal: true

# Generated via
#  `rails generate hyrax:work_resource JournalArticleResource`
class JournalArticleResource < Hyrax::Work
  include Hyrax::Schema(:basic_metadata)
  include Hyrax::Schema(:journal_article_resource)
  include Hyrax::Schema(:bulkrax_metadata)
  include Hyrax::Schema(:with_pdf_viewer)
  include Hyrax::Schema(:with_video_embed)

  include Hyrax::ArResource
  include Hyrax::NestedWorks

  Hyrax::ValkyrieLazyMigration.migrating(self, from: JournalArticle)

  include IiifPrint.model_configuration(
    pdf_split_child_model: JournalArticleResource,
    pdf_splitter_service: IiifPrint::SplitPdfs::AdventistPagesToJpgsSplitter,
    derivative_service_plugins: [
      IiifPrint::TextExtractionDerivativeService
    ]
  )

  prepend OrderAlready.for(:creator)
end