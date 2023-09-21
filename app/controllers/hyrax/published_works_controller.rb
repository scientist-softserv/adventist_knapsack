# frozen_string_literal: true

# Generated via
#  `rails generate hyrax:work PublishedWork`
module Hyrax
  # Generated controller for PublishedWork
  class PublishedWorksController < ApplicationController
    # Adds Hyrax behaviors to the controller.
    include Hyrax::WorksControllerBehavior
    include Hyrax::BreadcrumbsForWorks
    self.curation_concern_type = ::PublishedWork

    # Use this line if you want to use a custom presenter
    self.show_presenter = Hyrax::PublishedWorkPresenter
  end
end
