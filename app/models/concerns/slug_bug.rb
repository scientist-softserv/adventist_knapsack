# frozen_string_literal: true

module SlugBug
  extend ActiveSupport::Concern

  included do
    try(:before_save, :set_slug)
    # Cribbed from https://gitlab.com/notch8/louisville-hyku/-/blob/main/app/models/custom_slugs/slug_behavior.rb#L14
    try(:after_update, :remove_index_and_reindex)
  end

  def to_param
    slug_for_upgrade || slug || id
  end

  def set_slug
    self.slug = if aark_id.present?
                  (aark_id + "_" + title.first).truncate(75, omission: '').parameterize.underscore
                else
                  id
                end
    self.slug_for_upgrade = slug
  end

  private

    # Cribbed from https://gitlab.com/notch8/louisville-hyku/-/blob/main/app/models/custom_slugs/slug_behavior.rb#L14
    def remove_index_and_reindex
      return unless slug.present? || slug_for_upgrade.present?

      ActiveFedora::Base.remove_from_index!(id)
      update_index
    end
end

IiifPrint.config.ancestory_identifier_function = ->(work) { work.to_param }
