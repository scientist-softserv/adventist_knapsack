# frozen_string_literal: true

ImageResource.include Hyrax::Schema(:slug_metadata)
ImageResource.include(SlugBugValkyrie)
