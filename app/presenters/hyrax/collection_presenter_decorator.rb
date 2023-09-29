# frozen_string_literal: true

# OVERRIDE HYRAX 3.5.0
module Hyrax
  module CollectionPresenterDecorator
    module ClassMethods
      delegate(*Collection.additional_terms, to: :solr_document)

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

# Why singleton_class?  I tried to use ActiveSupport::Concern.included and .class_methods but this
# just didn't work.  Instead I'm leveraging the old-school Rails idiom of having a ClassMethods
# module; and prepending that to the singleton_class (e.g. make the methods of the ClassMethods
# module be class methods on the Hyrax::CollectionPresenter)
Hyrax::CollectionPresenter.singleton_class.send(:prepend, Hyrax::CollectionPresenterDecorator)
