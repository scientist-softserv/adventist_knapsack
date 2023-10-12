# frozen_string_literal: true

# Generated via
#  `rails generate dog_biscuits:work Thesis`
module Hyrax
  class ThesisForm < Hyrax::Forms::WorkForm
    self.model_class = Thesis
    self.terms += %i[
      video_embed
    ]

    self.terms -= DogBiscuits.config.base_properties
    self.terms += DogBiscuits.config.thesis_properties

    # Add any local properties here

    self.required_fields = %i[
      title
      rights_statement
    ]

    # The service that determines the cardinality of each field
    self.field_metadata_service = ::LocalFormMetadataService
  end
end
