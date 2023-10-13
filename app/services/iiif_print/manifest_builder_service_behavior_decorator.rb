# frozen_string_literal: true

module HykuKnapsack::ManifestBuilderServiceDecorator
  def build_manifest(presenter:)
    returning_hash = super
    returning_hash['rendering'] = rendering(presenter: presenter)
    returning_hash
  end

  def rendering(presenter:)
    file_set_presenters = presenter.file_set_presenters.reject { |fsp| fsp.mime_type.include?('image') }

    file_set_presenters.map do |fsp|
      {
        # Yes, we are using `#send` because `#hostname` is a private method, though I think it's okay here
        "@id": Hyrax::Engine.routes.url_helpers.download_url(fsp.id, host: presenter.send(:hostname)),
        "label": fsp.label,
        "format": fsp.mime_type
      }
    end
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
        apply_metadata_to_canvas(canvas: canvas, presenter: presenter, solr_doc_hits: solr_doc_hits)
      end
    end
    hash
  end

  def sanitize_label(label)
    CGI.unescapeHTML(sanitize_value(label))
  end
end
# rubocop:enable Metrics/BlockLength

Hyrax::ManifestBuilderService.prepend(HykuKnapsack::ManifestBuilderServiceDecorator)
