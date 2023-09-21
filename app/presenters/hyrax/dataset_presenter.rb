# frozen_string_literal: true

# Generated via
#  `rails generate hyrax:work Dataset`
# Updated by
#  `rails generate dog_biscuits:work Dataset`
module Hyrax
  class DatasetPresenter < Hyku::WorkShowPresenter
    class << self
      def delegated_properties
        props = DogBiscuits.config.dataset_properties
        controlled = Dataset.controlled_properties
        props.reject { |p| controlled.include? p }.concat(
          props.select { |p| controlled.include? p }.collect { |c| "#{c}_label".to_sym }
        )
      end
    end

    delegate(*delegated_properties, to: :solr_document)
  end
end
