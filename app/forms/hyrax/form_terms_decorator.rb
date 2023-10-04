# frozen_string_literal: true

module Hyrax
  module FormTermsDecorator
    def primary_terms
      super + %i[creator keyword]
    end
  end
end

Hyrax::FormTerms.prepend(Hyrax::FormTermsDecorator)

# Explicitly prepending to GenericWorkForm and ImageForm since
# .prepend didn't affect classes that include Hyrax::FormTerms
Hyrax::GenericWorkForm.prepend(Hyrax::FormTermsDecorator)
Hyrax::ImageForm.prepend(Hyrax::FormTermsDecorator)
