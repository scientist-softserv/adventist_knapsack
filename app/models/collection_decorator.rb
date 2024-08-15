# frozen_string_literal: true

module CollectionDecorator
  extend ActiveSupport::Concern

  # rubocop:disable Metrics/BlockLength, Metrics/MethodLength
  class_methods do
    def additional_terms
      %i[abstract
         alt
         date
         date_accepted
         date_available
         date_issued
         date_published
         date_submitted
         department
         doi
         former_identifier
         funder
         issue_number
         lat
         location
         long
         managing_organisation
         note
         official_url
         output_of
         pagination
         part_of
         place_of_publication
         publication_status].freeze
    end
  end
  # rubocop:enable Metrics/BlockLength, Metrics/MethodLength

  prepend OrderAlready.for(:creator)

  # What's going on here?
  #
  # Without the following two lines of code, we get the following error when we attempt to persist a
  # collection via the UI:
  #
  #   ActiveTriples::UndefinedPropertyError in Hyrax::Dashboard::CollectionsController#update
  #   The property `abstract` is not defined on class 'Collection::GeneratedResourceSchema'
  #
  # In my exploration, ActiveFedora::FedoraAttributes.resource_class is being called before we've
  # included the :abstract property (via the `include DogBiscuits::JournalArticleMetadata` line).
  # To circumvent this, I'm nullifying `@generated_resource_class` on the Collection and then
  # calling `Collection.resource_class`.
  #
  # Yes this is violating the rules of encapsulation, but this resolves the above exception.
  #
  # @see https://github.com/samvera/active_fedora/blob/6f48c18f919ed140682be05aba1b43a99461b3a7/lib/active_fedora/fedora_attributes.rb#L58-L69
  instance_variable_set(:@generated_resource_class, nil)
  Collection.resource_class
end

Collection.prepend(CollectionDecorator)
