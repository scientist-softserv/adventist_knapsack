# frozen_string_literal: true

# OVERRIDE IIIFManifest v0.5.0 to remove thumbnail and other non-image files from the manifest

module IIIFManifest
  module ManifestBuilderDecorator
    module CanvasBuilderFactoryDecorator
      def from(work)
        composite_builder.new(
          *file_set_presenters(work).map do |presenter|
            next if thumbnail?(presenter) || !presenter.image?
            canvas_builder_factory.new(presenter, work)
          end
        )
      end

      private

      # older filesets may not have original_filename_ssi indexed so fallback to label_ssi
      def thumbnail?(presenter)
        filename = presenter.solr_document['original_filename_ssi'] || presenter.solr_document['label_ssi']
        return false unless filename
        filename.end_with?(HykuKnapsack::Engine::THUMBNAIL_FILE_SUFFIX)
      end
    end
  end
end

IIIFManifest::ManifestBuilder::CanvasBuilderFactory
  .prepend(IIIFManifest::ManifestBuilderDecorator::CanvasBuilderFactoryDecorator)
