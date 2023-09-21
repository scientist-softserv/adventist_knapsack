# frozen_string_literal: true

# Generated via
#  `rails generate dog_biscuits:work ExamPaper`
module Hyrax
  class ExamPaperForm < Hyrax::Forms::WorkForm
    self.model_class = ExamPaper

    self.terms -= DogBiscuits.config.base_properties
    self.terms += DogBiscuits.config.exam_paper_properties

    # Add any local properties here
    self.terms += []

    self.required_fields = DogBiscuits.config.exam_paper_properties_required

    # The service that determines the cardinality of each field
    self.field_metadata_service = ::LocalFormMetadataService
  end
end
