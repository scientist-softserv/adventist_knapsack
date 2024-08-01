# frozen_string_literal: true

GenericWorkResourceForm.include Hyrax::FormFields(:slug_metadata)
GenericWorkResourceForm.include(SlugBugValkyrie)
