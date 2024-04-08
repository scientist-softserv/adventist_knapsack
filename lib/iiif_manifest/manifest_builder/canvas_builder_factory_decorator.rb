# frozen_string_literal: true

# OVERRIDE IIIFManifest v0.5.0 to remove thumbnail and other non-image files from the manifest

module IIIFManifest
  module ManifestBuilderDecorator
    module CanvasBuilderFactoryDecorator
      def from(work)
        composite_builder.new(
          *file_set_presenters(work).map do |presenter|
            next if presenter.label.downcase.end_with?(Hyku::THUMBNAIL_FILE_SUFFIX) || !presenter.image?
            canvas_builder_factory.new(presenter, work)
          end
        )
      end
    end
  end
end

IIIFManifest::ManifestBuilder::CanvasBuilderFactory
  .prepend(IIIFManifest::ManifestBuilderDecorator::CanvasBuilderFactoryDecorator)
