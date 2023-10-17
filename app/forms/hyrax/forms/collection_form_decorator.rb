# frozen_string_literal: true

##
# Yes, this needs to be HykuKnapsack.  In prior commits, we had Hyrax and the specs failed (because
# Hyku has a Hyrax::Forms::CollectionFormDecorator which was getting loaded/parsed and collaborating
# on the problem regarding {alternative_title}).
module HykuKnapsack
  module Forms
    module CollectionFormDecorator
      # Terms that appear within the accordion
      def secondary_terms
        (super + Collection.additional_terms - [:alternative_title]).sort.uniq
      end

      ##
      # What the heck is going on here?
      #
      # As part of https://github.com/scientist-softserv/adventist_knapsack/pull/87 we have
      # attempted to rid the collection form of the alternative_title (to deal with the conflicting
      # predicate for slugs).  However, it is declared by way of
      # `Hyrax::Forms::CollectionForm.delegate(:alternative_title, to: :model)`
      #
      # Which means that we cannot rely on `remove_method` to tidy this up.  Instead we declare the
      # method (thus obliterating the delegation).  We then use Ruby's `undef_method` which
      # instructs the object to no longer `respond_to` the undefined method.  See the tests for
      # clarification.
      #
      # Yes, I'm saying NotImplementedError and testing for NoMethodError; because `undef_method`
      # cleans this mess up.
      def alternative_title
        raise NotImplementedError, "Removed #{self.class}#alternative_title for Slug interaction."
      end
      undef_method(:alternative_title)
    end
  end
end

Hyrax::Forms::CollectionForm.terms += Collection.additional_terms
Hyrax::Forms::CollectionForm.terms -= [:alternative_title]
Hyrax::Forms::CollectionForm.prepend(HykuKnapsack::Forms::CollectionFormDecorator)
