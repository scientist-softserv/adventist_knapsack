# frozen_string_literal: true

module HykuKnapsack
  module ManifestBuilderServiceDecorator
    def build_manifest(presenter:)
      returning_hash = super
      returning_hash['rendering'] = rendering(presenter:)
      returning_hash
    end

    def sanitize_v2(hash:, presenter:, solr_doc_hits:)
      hash['label'] = sanitize_label(hash['label']) if hash.key?('label')
      hash.delete('description') # removes default description since it's in the metadata fields
      hash['sequences']&.each do |sequence|
        # removes canvases if there are thumbnail files
        sequence['canvases'].reject! do |canvas|
          sanitize_label(canvas['label']).end_with?('.TN.jpg')
        end

        sequence['canvases']&.each do |canvas|
          canvas['label'] = sanitize_label(canvas['label'])
          apply_metadata_to_canvas(canvas:, presenter:, solr_doc_hits:)
        end
      end
      hash
    end

    private

    def rendering(presenter:)
      model = presenter.solr_document['has_model_ssim'].first
      # Our current presenter is a IiifManifestPresenter, which doesn't have the file_set_presenters we need.
      # So we create a Hyrax presenter for the model, and use that to get the file_set_presenters.
      hyrax_presenter = "Hyrax::#{model}Presenter".constantize.new(presenter, presenter.ability)
      file_set_presenters = hyrax_presenter.file_set_presenters.reject { |fsp| fsp.mime_type&.include?('image') }

      file_set_presenters.map do |fsp|
        {
          # Yes, we are using `#send` because `#hostname` is a private method, though I think it's okay here
          "@id": Hyrax::Engine.routes.url_helpers.download_url(fsp.id,
                                                               host: presenter.send(:hostname),
                                                               protocol: 'https'),
          "label": fsp.label,
          "format": fsp.mime_type
        }
      end
    end

    def sanitize_label(label)
      CGI.unescapeHTML(sanitize_value(label))
    end
  end
end

Hyrax::ManifestBuilderService.prepend(HykuKnapsack::ManifestBuilderServiceDecorator)
