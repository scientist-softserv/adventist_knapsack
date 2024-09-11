# frozen_string_literal: true

# Generated via
#  `rails generate hyrax:work_resource ConferenceItemResource`
class ConferenceItemResource < Hyrax::Work
  # Commented out basic_metadata because these terms were added to conference_item_resource so we can customize it.
  # include Hyrax::Schema(:basic_metadata)
  include Hyrax::Schema(:adl_metadata)
  include Hyrax::Schema(:conference_item_resource)
  include Hyrax::Schema(:bulkrax_metadata)
  include Hyrax::Schema(:with_pdf_viewer)
  include Hyrax::Schema(:with_video_embed)
  include Hyrax::Schema(:slug_metadata)
  include SlugBugValkyrie
  include Hyrax::ArResource
  include Hyrax::NestedWorks

  Hyrax::ValkyrieLazyMigration.migrating(self, from: ConferenceItem)

  include IiifPrint.model_configuration(
    pdf_split_child_model: ConferenceItemResource,
    pdf_splitter_service: IiifPrint::SplitPdfs::AdventistPagesToJpgsSplitter,
    derivative_service_plugins: [
      IiifPrint::TextExtractionDerivativeService
    ]
  )

  prepend OrderAlready.for(:creator)
end
