module FileSetDecorator
  extend ActiveSupport::Concern

  included do
    property :override_default_thumbnail,
      predicate: ::RDF::URI.intern('https://b2.adventistdigitallibrary.org/terms/overrideDefaultThumbnail'),
      multiple: false do |index|
        index.as :stored_searchable
      end
    attr_accessor :default_thumbnail
  end
end

FileSet.include FileSetDecorator
