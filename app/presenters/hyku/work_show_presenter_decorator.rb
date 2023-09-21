# frozen_string_literal: true

module Hyku
  module WorkShowPresenterDecorator
    def video_embed_viewer?
      solr_document[:video_embed_tesim].present?
    end

    def video_embed_viewer
      :video_embed_viewer
    end
  end
end

Hyku::WorkShowPresenter.prepend Hyku::WorkShowPresenterDecorator
Hyku::WorkShowPresenter.delegate :bibliographic_citation, :alt, to: :solr_document
