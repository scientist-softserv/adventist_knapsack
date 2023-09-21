# frozen_string_literal: true

module Hyrax
  module CollectionPresenterDecorator
    module ClassMethods
      delegate(*Collection::ADDITIONAL_TERMS, to: :solr_document)

      # Terms is the list of fields displayed by
      # app/views/collections/_show_descriptions.html.erb
      def terms
        super + Collection::ADDITIONAL_TERMS
      end
    end
  end
end

# Why singleton_class?  I tried to use ActiveSupport::Concern.included and .class_methods but this
# just didn't work.  Instead I'm leveraging the old-school Rails idiom of having a ClassMethods
# module; and prepending that to the singleton_class (e.g. make the methods of the ClassMethods
# module be class methods on the Hyrax::CollectionPresenter)
Hyrax::CollectionPresenter.singleton_class.send(:prepend, Hyrax::CollectionPresenterDecorator::ClassMethods)
