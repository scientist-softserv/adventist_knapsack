# frozen_string_literal: true

# added the module here so it is picked up by the "include" in the dog biscuit models

module DogBiscuits
  module RemoteUrl
    extend ActiveSupport::Concern

    included do
      property :remote_url, predicate: ::RDF::Vocab::Identifiers.uri do |index|
        index.as :stored_searchable
      end
    end
  end
end
