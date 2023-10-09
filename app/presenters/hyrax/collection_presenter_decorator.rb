# frozen_string_literal: true

# OVERRIDE HYRAX 3.5.0
module Hyrax
  module CollectionPresenterDecorator
    module ClassMethods
      # Terms is the list of fields displayed by
      # app/views/collections/_show_descriptions.html.erb
      def terms
        super + Collection.additional_terms
      end
    end

    def terms_with_values
      # OVERRIDE HYRAX 3.5.0 to hide identifier line
      terms = self.class.terms - [:identifier]
      terms.select { |t| self[t].present? }
    end
  end
end

Hyrax::CollectionPresenter.delegate(*Collection.additional_terms, to: :solr_document)
Hyrax::CollectionPresenter.prepend(Hyrax::CollectionPresenterDecorator)
Hyrax::CollectionPresenter.singleton_class.prepend(Hyrax::CollectionPresenterDecorator::ClassMethods)
