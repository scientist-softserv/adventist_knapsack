# frozen_string_literal: true

module VideoEmbedViewer
  extend ActiveSupport::Concern

  included do
    # adding video embed option various work types
    property :video_embed, predicate: ::RDF::URI("https://schema.org/embedUrl"), multiple: false do |index|
      index.as :stored_searchable
    end

    # rubocop:disable Style/RegexpLiteral
    validates :video_embed,
              format: {
                # regex matches only youtube & vimeo urls that are formatted as embed links.
                with: /(http:\/\/|https:\/\/)(www\.)?(player\.vimeo\.com|youtube\.com\/embed)/,
                message: "Error: must be a valid YouTube or Vimeo Embed URL."
              },
              if: :video_embed?
    # rubocop:enable Style/RegexpLiteral

    def video_embed?
      video_embed.present?
    end
  end
end
