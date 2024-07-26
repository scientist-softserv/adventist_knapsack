# frozen_string_literal: true

module SlugBugValkyrie
  # @todo: set_slug before saving
  # @todo: potentially handle removing index & reindexing after updating if necessary...
  #        if the slug changed, we could possibly have stray indexes left behind.

  def to_param
    slug || id
  end

  def set_slug
    self.slug = if aark_id.present?
                  (aark_id + "_" + title.first).truncate(75, omission: '').parameterize.underscore
                else
                  id
                end
  end
end
