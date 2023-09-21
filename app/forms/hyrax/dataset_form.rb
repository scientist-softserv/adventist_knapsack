# frozen_string_literal: true

# Generated via
#  `rails generate dog_biscuits:work Dataset`
module Hyrax
  class DatasetForm < Hyrax::Forms::WorkForm
    self.model_class = Dataset
    self.terms += %i[
      video_embed
    ]

    self.terms -= DogBiscuits.config.base_properties
    self.terms += DogBiscuits.config.dataset_properties

    # Add any local properties here

    self.required_fields = DogBiscuits.config.dataset_properties_required

    # The service that determines the cardinality of each field
    self.field_metadata_service = ::LocalFormMetadataService
  end
end
