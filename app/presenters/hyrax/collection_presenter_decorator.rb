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
  end
end

Hyrax::CollectionPresenter.singleton_class.prepend(Hyrax::CollectionPresenterDecorator::ClassMethods)
