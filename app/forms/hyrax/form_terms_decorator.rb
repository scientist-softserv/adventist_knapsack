# frozen_string_literal: true

module Hyrax
  module FormTermsDecorator

    # include Hyrax::Forms
    # overrides Hyrax::Forms::WorkForm
    # to display 'license' in the 'base-terms' div on the user dashboard "Add New Work" description
    # by getting iterated over in hyrax/app/views/hyrax/base/_form_metadata.html.erb
    def primary_terms
      super + %i[creator keyword]
    end
  end
end

Hyrax::FormTerms.prepend(Hyrax::FormTermsDecorator)