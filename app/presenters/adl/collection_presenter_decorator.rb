# frozen_string_literal: true

# OVERRIDE HYRAX 3.5.0
module Adl
  module CollectionPresenterDecorator
    module ClassMethods
      # Terms is the list of fields displayed by
      # app/views/collections/_show_descriptions.html.erb
      def terms
        super - [:size] + Collection.additional_terms
      end
    end
  end
end

Hyrax::CollectionPresenter.singleton_class.prepend(Adl::CollectionPresenterDecorator::ClassMethods)
