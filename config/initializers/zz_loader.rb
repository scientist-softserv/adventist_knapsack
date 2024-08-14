# frozen_string_literal: true

# This is the opposite of what you usually want to do.  Normally app views override engine
# views and app decorators override engine decorators but in our case things in the Knapsack
# override what is in the application.
#
# Furthermore we need to account for when the ApplicationController and it's descendants set
# their individual view_paths.  By looping through all descendants, we ensure that we have
# the Knapsack views at the beginning of the list of view_paths.
#
# In the load sequence, when we load ApplicationController, we establish the view_path for all
# future descendants.  When we then encounter a descendant, we copy the
# ApplicationController's view_path to the descendant; then later after we've encountered most
# all of the descendants we updated the ApplicationController's view_path, but that does not
# propogate to the descendants' copied view_path.
Rails.application.config.to_prepare do
  HykuKnapsack::Engine.root.glob("app/**/*_decorator*.rb").sort.each do |c|
    Rails.configuration.cache_classes ? require(c) : load(c)
  end

  HykuKnapsack::Engine.root.glob("lib/**/*_decorator*.rb").sort.each do |c|
    Rails.configuration.cache_classes ? require(c) : load(c)
  end

  ([::ApplicationController] + ::ApplicationController.descendants).each do |klass|
    paths = klass.view_paths.collect(&:to_s)
    paths = [HykuKnapsack::Engine.root.join('app', 'views').to_s] + paths
    klass.view_paths = paths.uniq
  end
  ::ApplicationController.send :helper, HykuKnapsack::Engine.helpers

  GenericWorkResourceForm.include Hyrax::FormFields(:slug_metadata)
  GenericWorkResourceForm.include(SlugBugValkyrie)
  ImageResourceForm.include Hyrax::FormFields(:slug_metadata)
  ImageResourceForm.include(SlugBugValkyrie)

  Hyrax::Forms::CollectionForm.terms += ::Collection.additional_terms
  ::Collection.include ::Hyrax::CollectionBehavior
  ::Collection.include SlugMetadata
  ::Collection.include AdventistMetadata
  ::Collection.include DogBiscuits::JournalArticleMetadata
  ::Collection.include DogBiscuits::BibliographicCitation
  ::Collection.include DogBiscuits::DateIssued
  ::Collection.include DogBiscuits::Geo
  ::Collection.include DogBiscuits::PlaceOfPublication
  ::Collection.include DogBiscuits::RemoteUrl
  Hyrax::CollectionPresenter.delegate(*::Collection.additional_terms, to: :solr_document)
end
