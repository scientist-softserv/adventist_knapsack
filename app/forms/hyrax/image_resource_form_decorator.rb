# frozen_string_literal: true

ImageResourceForm.include Hyrax::FormFields(:slug_metadata)
ImageResourceForm.include(SlugBugValkyrie)