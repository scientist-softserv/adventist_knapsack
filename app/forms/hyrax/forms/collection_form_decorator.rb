# frozen_string_literal: true

module Hyrax
  module Forms
    module CollectionFormDecorator
      # Terms that appear within the accordion
      def secondary_terms
        (super + Collection.additional_terms).sort
      end
    end
  end
end

Hyrax::Forms::CollectionForm.terms += Collection.additional_terms
Hyrax::Forms::CollectionForm.prepend(Hyrax::Forms::CollectionFormDecorator)
