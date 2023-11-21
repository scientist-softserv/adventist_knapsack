# frozen_string_literal: true

module Hyku
  module WorkShowPresenterDecorator
    def video_embed_viewer?
      solr_document[:video_embed_tesim].present?
    end

    def video_embed_viewer
      :video_embed_viewer
    end

    def part_of_label
      klass = model_klass
      klass == JournalArticle ? 'Periodical' : 'Part Of'
    end

    private

      def model_klass
        model_name.instance_variable_get(:@klass)
      end
  end
end

Hyku::WorkShowPresenter.prepend Hyku::WorkShowPresenterDecorator
Hyku::WorkShowPresenter.delegate :bibliographic_citation, :alt, to: :solr_document
