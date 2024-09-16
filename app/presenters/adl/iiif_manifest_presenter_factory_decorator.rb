# frozen_string_literal: true

# OVERRIDE IiifPrint v3.0.1 to check has_model instead of hydra_model.
# Hyrax.config.curation_concerns does not include "Resource"

module Adl
  module IiifManifestPresenterFactoryDecorator
    # This will override Hyrax::IiifManifestPresenter::Factory#build and introducing
    # the expected behavior:
    # - child work images show as canvases in the parent work manifest
    # - child work images show in the uv on the parent show page
    # - still create the manifest if the parent work has images attached but the child works do not
    def build
      ids.map do |id|
        solr_doc = load_docs.find { |doc| doc.id == id }
        next unless solr_doc

        if solr_doc.file_set?
          presenter_class.for(solr_doc)
        # OVERRIDE IiifPrint: elsif Hyrax.config.curation_concerns.include?(solr_doc.hydra_model)
        elsif Hyrax.config.curation_concerns.include?(solr_doc["has_model_ssim"].first.constantize)
          # look up file set ids and loop through those
          file_set_docs = load_file_set_docs(solr_doc.try(:member_ids) || solr_doc.try(:[], 'member_ids_ssim'))
          file_set_docs.map { |doc| presenter_class.for(doc) } if file_set_docs.length
        end
      end.flatten.compact
    end
  end
end

Hyrax::IiifManifestPresenter::Factory.prepend(Adl::IiifManifestPresenterFactoryDecorator)
