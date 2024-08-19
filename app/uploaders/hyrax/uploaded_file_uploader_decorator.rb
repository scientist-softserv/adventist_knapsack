# frozen_string_literal: true
module Hyrax
  module UploadedFileUploaderDecorator
    # Override Hyrax 5 to fetch the filename if available
    def filename
      original_file_name || super
    end

    def original_file_name
      model.filename
    end
  end
end

Hyrax::UploadedFileUploader.prepend(Hyrax::UploadedFileUploaderDecorator)
