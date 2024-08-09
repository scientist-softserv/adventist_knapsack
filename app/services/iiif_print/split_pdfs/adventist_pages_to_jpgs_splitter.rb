# frozen_string_literal: true

module IiifPrint
  module SplitPdfs
    module AdventistPagesToJpgsSplitter
      ##
      # @param path [String] the path, in particular filename (that hopefully ends with an
      #        extension).
      #
      # @param suffixes [Array<String>] the list of suffixes that we want to ignore for splitting.
      # @return [TrueClass] when we should be splitting this path.
      # @return [TrueClass] when we should not be splitting this path.
      def self.split_this?(path:, suffixes: CreateDerivativesJobDecorator::NON_ARCHIVAL_PDF_SUFFIXES)
        suffixes.none? { |suffix| path.downcase.end_with?(suffix) }
      end

      ##
      # We do not always want to split a PDF; this provides a decision point.
      #
      # @param path [String] the path of the file we're attempting to run derivatives against.
      # @param args [Array<Object>] pass through args
      # @param splitter [IiifPrint::SplitPdfs::BaseSplitter] (for dependency injection)
      # @param suffixes [String] (for dependency injection)
      #
      # @return [Enumerable] when we are going to skip splitting, return an empty array; otherwise return
      #         an instance of {IiifPrint::SplitPdfs::AdventistPagesToJpgsSplitter}.
      # @note I am adding a {.new} method to a module to mimic the instantiation of a class.
      #
      # @see https://github.com/scientist-softserv/iiif_print/blob/a23706453f23e0f54c9d50bbf0ddf9311d82a0b9/lib/iiif_print/jobs/child_works_from_pdf_job.rb#L39-L63
      def self.call(path,
                    splitter: DerivativeRodeoSplitter,
                    suffixes: CreateDerivativesJobDecorator::NON_ARCHIVAL_PDF_SUFFIXES,
                    **args)
        return [] unless AdventistPagesToJpgsSplitter.split_this?(path: path, suffixes: suffixes)

        splitter.call(path, **args)
      end
    end
  end
end
