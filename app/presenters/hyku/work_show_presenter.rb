# frozen_string_literal: true

module Hyku
  class WorkShowPresenter < Hyrax::WorkShowPresenter
    Hyrax::MemberPresenterFactory.file_presenter_class = Hyrax::FileSetPresenter

    delegate :bibliographic_citation, :extent, :alt, to: :solr_document

    # assumes there can only be one doi
    def doi
      doi_regex = %r{10\.\d{4,9}\/[-._;()\/:A-Z0-9]+}i
      doi = extract_from_identifier(doi_regex)
      doi&.join
    end

    # unlike doi, there can be multiple isbns
    def isbns
      isbn_regex = /((?:ISBN[- ]*13|ISBN[- ]*10|)\s*97[89][ -]*\d{1,5}[ -]*\d{1,7}[ -]*\d{1,6}[ -]*\d)|
                    ((?:[0-9][-]*){9}[ -]*[xX])|(^(?:[0-9][-]*){10}$)/x
      isbns = extract_from_identifier(isbn_regex)
      isbns&.flatten&.compact
    end

    def video_embed_viewer?
      solr_document[:video_embed_tesim].present?
    end

    def video_embed_viewer
      :video_embed_viewer
    end

    def pdf_viewer?
      return unless Flipflop.default_pdf_viewer?
      return unless file_set_presenters.any?(&:pdf?) || pdf_extension?

      # If all of the member_presenters are file_set presenters, return true
      # this also means that there are no child works
      member_presenters.all? { |presenter| presenter.is_a? Hyrax::FileSetPresenter }
    end

    def pdf_extension?
      file_set_presenters.any? { |fsp| fsp.label.downcase.end_with?('.pdf') }
    end

    def viewer?
      iiif_viewer? || video_embed_viewer? || pdf_viewer?
    end

    private

      def extract_from_identifier(rgx)
        if solr_document['identifier_tesim'].present?
          ref = solr_document['identifier_tesim'].map do |str|
            str.scan(rgx)
          end
        end
        ref
      end
  end
end
