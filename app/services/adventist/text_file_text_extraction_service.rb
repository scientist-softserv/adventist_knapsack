# frozen_string_literal: true

module Adventist
  # This class conforms to the interface of a Hyrax::DerivativeService
  #
  # @see https://github.com/samvera/hyrax/blob/cff1ddd18764e4d14a2404d61d20ae776ea62916/app/services/hyrax/derivative_service.rb#L1
  #      v2.9.5 implementation of Hyrax::DerivativeService
  class TextFileTextExtractionService
    # @param file_set [FileSet]
    # @param text [String] the text of the original_file_name
    # @param original_file_name [String] the base name of the original file (e.g. no pathing)
    #
    # @raise [ActiveFedora::RecordInvalid] when the file_set is not valid
    def self.assign_extracted_text(file_set:, text:, original_file_name:)
      file_set.build_extracted_text.tap do |extracted_text|
        # In testing, we encountered errors with the file's character encoding
        # (e.g. `Encoding::UndefinedConversionError`).  The following will force the encoding to
        # UTF-8 and replace any invalid or undefined characters from the original encoding with a
        # "?".
        #
        # Given that we still have the original, and this is a derivative, the forced encoding
        # should be acceptable.
        extracted_text.content = Hyku.utf_8_encode(text)
        extracted_text.mime_type = file_set.mime_type
        extracted_text.original_name = original_file_name
      end
      file_set.save!
    end

    VALID_MIME_TYPES = ["text/plain"].freeze
    attr_reader :file_set
    delegate :mime_type, :uri, to: :file_set
    def initialize(file_set)
      @file_set = file_set
    end

    def cleanup_derivatives; end

    # This is an short-circuit and amalgemation of logic for the Hyrax::DerivativeService ecosystem.
    #
    # It follows the logic of the following points in the shared code-base:
    #
    # - https://github.com/samvera/hyrax/blob/cff1ddd18764e4d14a2404d61d20ae776ea62916/app/services/hyrax/file_set_derivatives_service.rb#L99-L107
    # - https://github.com/samvera/hyrax/blob/cff1ddd18764e4d14a2404d61d20ae776ea62916/app/models/concerns/hyrax/file_set/derivatives.rb#L46
    # - https://github.com/samvera/hyrax/blob/cff1ddd18764e4d14a2404d61d20ae776ea62916/app/services/hyrax/persist_directly_contained_output_file_service.rb
    # - https://github.com/samvera/hydra-derivatives/blob/f781d112e05155c90d3de9c6bc05308864ecb1cf/lib/hydra/derivatives/processors/full_text.rb#L1
    # - https://github.com/samvera/hydra-derivatives/blob/f781d112e05155c90d3de9c6bc05308864ecb1cf/lib/hydra/derivatives/services/persist_basic_contained_output_file_service.rb#L16-L23
    # - https://github.com/samvera/hydra-derivatives/blob/f781d112e05155c90d3de9c6bc05308864ecb1cf/lib/hydra/derivatives/services/persist_output_file_service.rb
    # - https://github.com/samvera/hydra-derivatives/blob/f781d112e05155c90d3de9c6bc05308864ecb1cf/lib/hydra/derivatives/runners/full_text_extract.rb
    #
    # But avoids the trip to Solr for the extracted text.
    #
    # @see https://github.com/samvera/hyrax/blob/cff1ddd18764e4d14a2404d61d20ae776ea62916/app/services/hyrax/file_set_derivatives_service.rb#L99-L107
    #      Hyrax::FileSetDerivatives#extract_full_text
    def create_derivatives(filename)
      self.class.assign_extracted_text(
        file_set: file_set,
        text: File.read(filename),
        original_file_name: filename
      )
    end

    # @note This is not does not appear to be a necessary method for the interface.
    def derivative_url(_destination_name)
      ""
    end

    def valid?
      return true if VALID_MIME_TYPES.detect do |valid_mime_type|
        # Because character encoding may be part of the mime_type.  So we want both "text/plain" and
        # "text/plain;charset=UTF-8" to be a valid type.
        valid_mime_type.start_with?(mime_type)
      end
    end
  end
end
