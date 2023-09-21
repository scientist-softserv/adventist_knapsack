# frozen_string_literal: true

# Generated via
#  `rails generate hyrax:work JournalArticle`
module Hyrax
  # Generated controller for JournalArticle
  class JournalArticlesController < ApplicationController
    # Adds Hyrax behaviors to the controller.
    include Hyrax::WorksControllerBehavior
    include Hyrax::BreadcrumbsForWorks
    self.curation_concern_type = ::JournalArticle

    # Use this line if you want to use a custom presenter
    self.show_presenter = Hyrax::JournalArticlePresenter
  end
end
