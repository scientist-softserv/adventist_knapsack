# frozen_string_literal: true

# OVERRIDE Hyrax 3.5.0 to add PDF text to solr document when using the default PDF viewer (PDF.js)

module Hyrax
  module FileSetIndexerDecorator
    def generate_solr_document
      return super unless Flipflop.default_pdf_viewer?
      return super unless object.pdf?
      return super unless object.original_file&.content.is_a? String

      super.tap do |solr_doc|
        solr_doc['all_text_timv'] = solr_doc['all_text_tsimv'] = pdf_text
      end
    end

    private

      def pdf_text
        text = IO.popen(['pdftotext', '-', '-'], 'r+b') do |pdftotext|
          pdftotext.write(object.original_file.content)
          pdftotext.close_write
          pdftotext.read
        end

        text.tr("\n", ' ')
            .squeeze(' ')
            .encode('UTF-8', 'binary', invalid: :replace, undef: :replace, replace: '') # remove non-UTF-8 characters
      end
  end
end

Hyrax::FileSetIndexer.prepend(Hyrax::FileSetIndexerDecorator)
