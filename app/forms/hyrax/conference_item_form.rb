# frozen_string_literal: true

# Generated via
#  `rails generate dog_biscuits:work ConferenceItem`
module Hyrax
  class ConferenceItemForm < Hyrax::Forms::WorkForm
    self.model_class = ConferenceItem
    self.terms += %i[
      video_embed
    ]

    self.terms -= DogBiscuits.config.base_properties
    self.terms += DogBiscuits.config.conference_item_properties

    # Add any local properties here

    self.required_fields = DogBiscuits.config.conference_item_properties_required

    # The service that determines the cardinality of each field
    self.field_metadata_service = ::LocalFormMetadataService
  end
end
