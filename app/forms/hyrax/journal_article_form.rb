# frozen_string_literal: true

# Generated via
#  `rails generate dog_biscuits:work JournalArticle`
module Hyrax
  class JournalArticleForm < Hyrax::Forms::WorkForm
    self.model_class = JournalArticle

    self.terms -= DogBiscuits.config.base_properties
    self.terms += DogBiscuits.config.journal_article_properties

    # Add any local properties here
    self.terms += []

    self.required_fields = DogBiscuits.config.journal_article_properties_required

    # The service that determines the cardinality of each field
    self.field_metadata_service = ::LocalFormMetadataService
  end
end
