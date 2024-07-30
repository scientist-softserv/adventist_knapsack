# frozen_string_literal: true

module SlugBugValkyrie
  def to_param
    slug || id.to_s
  end

  def set_slug
    if aark_id.present?
      (aark_id + "_" + title.first).truncate(75, omission: '').parameterize.underscore
    else
      id.to_s
    end
  end
end
