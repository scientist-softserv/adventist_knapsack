# frozen_string_literal: true

GenericWorkResource.include Hyrax::Schema(:slug_metadata)
GenericWorkResource.include(SlugBugValkyrie)
