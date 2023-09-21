# frozen_string_literal: true

module SlugBug
  extend ActiveSupport::Concern

  included do
    before_save :set_slug
    # Cribbed from https://gitlab.com/notch8/louisville-hyku/-/blob/main/app/models/custom_slugs/slug_behavior.rb#L14
    after_update :remove_index_and_reindex
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

      # if we have a slug with an existing record, previous indexes would have a different id,
      # resulting extraneous solr indexes remaining (one fedora object with two solr indexes to it)
      #   1) This happens when a slug gets changed from either empty or a different value
      #   2) It also apparently happens in some situations where data existed prior to the slug logic
      # Testing for situation slug_changed? did not adequately prevent the second situation.
      # This query finds everything indexed by fedora id. The new index will have id: slug
      Blacklight.default_index.connection.delete_by_query('id:"' + id + '"')
      # This query finds everything else for this fedora id... if slug changed, may be something here.
      Blacklight.default_index.connection.delete_by_query('fedora_id_ssi:"' + id + '"')
      Blacklight.default_index.connection.commit
      update_index
    end
end

IiifPrint.config.ancestory_identifier_function = ->(work) { work.to_param }
