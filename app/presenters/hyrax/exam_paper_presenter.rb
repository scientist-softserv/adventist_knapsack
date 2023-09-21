# frozen_string_literal: true

# Generated via
#  `rails generate hyrax:work ExamPaper`
# Updated by
#  `rails generate dog_biscuits:work ExamPaper`
module Hyrax
  class ExamPaperPresenter < Hyku::WorkShowPresenter
    class << self
      def delegated_properties
        props = DogBiscuits.config.exam_paper_properties
        controlled = ExamPaper.controlled_properties
        props.reject { |p| controlled.include? p }.concat(
          props.select { |p| controlled.include? p }.collect { |c| "#{c}_label".to_sym }
        )
      end
    end

    delegate(*delegated_properties, to: :solr_document)
  end
end
