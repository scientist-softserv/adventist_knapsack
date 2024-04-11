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

    def pdf_viewer?
      return unless Flipflop.default_pdf_viewer?
      return unless file_set_presenters.any?(&:pdf?) || pdf_extension?

      # If all of the member_presenters are file_set presenters, return true
      # this also means that there are no child works
      member_presenters.all? { |presenter| presenter.is_a? Hyrax::FileSetPresenter }
    end

    def pdf_extension?
      file_set_presenters.any? { |fsp| fsp&.label&.downcase&.end_with?('.pdf') }
    end

    def viewer?
      iiif_viewer? || video_embed_viewer? || pdf_viewer?
    end
    private

      def model_klass
        model_name.instance_variable_get(:@klass)
      end
  end
end

Hyku::WorkShowPresenter.prepend Hyku::WorkShowPresenterDecorator
Hyku::WorkShowPresenter.delegate :bibliographic_citation, :alt, to: :solr_document
