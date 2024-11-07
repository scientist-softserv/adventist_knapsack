Rails.application.config.to_prepare do
  WINGS_CONCERNS = [AdminSet, Collection, ConferenceItem, Dataset, Etd, ExamPaper, GenericWork, Image, JournalArticle, Oer, PublishedWork, Thesis].freeze
end

Rails.application.config.after_initialize do
  Valkyrie::MetadataAdapter.register(
    Freyja::MetadataAdapter.new,
    :freyja
  )
  Valkyrie.config.metadata_adapter = :freyja

  Hyrax.query_service.services[0].custom_queries.register_query_handler(Hyrax::CustomQueries::FindBySlug)
  Hyrax.query_service.services[1].custom_queries.register_query_handler(Wings::CustomQueries::FindBySlug)
end