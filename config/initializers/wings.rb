# frozen_string_literal: true
# rubocop:disable Metrics/BlockLength

Rails.application.config.after_initialize do
  # Add all concerns that are migrating from ActiveFedora here
  CONCERNS = [ConferenceItem, Dataset, ExamPaper, GenericWork, Image, JournalArticle, PublishedWork, Thesis].freeze

  CONCERNS.each do |klass|
    Wings::ModelRegistry.register("#{klass}Resource".constantize, klass)
    # we register itself so we can pre-translate the class in Freyja instead of having to translate in each query_service
    Wings::ModelRegistry.register(klass, klass)
  end

  Wings::ModelRegistry.register(ConferenceItemResource, ConferenceItem)
  Wings::ModelRegistry.register(DatasetResource, Dataset)
  Wings::ModelRegistry.register(ExamPaperResource, ExamPaper)
  Wings::ModelRegistry.register(GenericWorkResource, GenericWork)
  Wings::ModelRegistry.register(ImageResource, Image)
  Wings::ModelRegistry.register(JournalArticleResource, JournalArticle)
  Wings::ModelRegistry.register(PublishedWorkResource, PublishedWork)
  Wings::ModelRegistry.register(ThesisResource, Thesis)

  Valkyrie.config.resource_class_resolver = lambda do |resource_klass_name|
    # TODO: Can we use some kind of lookup.
    klass_name = resource_klass_name.gsub(/Resource$/, '')
    if CONCERNS.map(&:to_s).include?(klass_name)
      "#{klass_name}Resource".constantize
    elsif 'Collection' == klass_name
      CollectionResource
    elsif 'AdminSet' == klass_name
      AdminSetResource
    # Without this mapping, we'll see cases of Postgres Valkyrie adapter attempting to write to
    # Fedora.  Yeah!
    elsif 'Hydra::AccessControl' == klass_name
      Hyrax::AccessControl
    elsif 'FileSet' == klass_name
      Hyrax::FileSet
    elsif 'Hydra::AccessControls::Embargo' == klass_name
      Hyrax::Embargo
    elsif 'Hydra::AccessControls::Lease' == klass_name
      Hyrax::Lease
    elsif 'Hydra::PCDM::File' == klass_name
      Hyrax::FileMetadata
    else
      klass_name.constantize
    end
  end

  Valkyrie::MetadataAdapter.register(
    Freyja::MetadataAdapter.new,
    :freyja
  )
  Valkyrie.config.metadata_adapter = :freyja

  Hyrax.query_service.services[0].custom_queries.register_query_handler(Hyrax::CustomQueries::FindBySlug)
  Hyrax.query_service.services[1].custom_queries.register_query_handler(Wings::CustomQueries::FindBySlug)
end
# rubocop:enable Metrics/BlockLength
