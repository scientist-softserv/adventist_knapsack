# frozen_string_literal: true

module Hyrax
  module Forms
    module CollectionFormDecorator
      # Terms that appear within the accordion
      def secondary_terms
        (super + Collection::ADDITIONAL_TERMS).sort
      end
    end
  end
end

Hyrax::Forms::CollectionForm.terms += Collection::ADDITIONAL_TERMS
Hyrax::Forms::CollectionForm.prepend(Hyrax::Forms::CollectionFormDecorator)
