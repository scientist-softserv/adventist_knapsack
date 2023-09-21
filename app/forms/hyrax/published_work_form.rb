# frozen_string_literal: true

# Generated via
#  `rails generate dog_biscuits:work PublishedWork`
module Hyrax
  class PublishedWorkForm < Hyrax::Forms::WorkForm
    self.model_class = PublishedWork
    self.terms += %i[
      video_embed
    ]

    self.terms -= DogBiscuits.config.base_properties
    self.terms += DogBiscuits.config.published_work_properties

    # Add any local properties here

    self.required_fields = DogBiscuits.config.published_work_properties_required

    # The service that determines the cardinality of each field
    self.field_metadata_service = ::LocalFormMetadataService
  end
end
