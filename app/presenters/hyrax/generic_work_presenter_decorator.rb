# frozen_string_literal: true

# Generated via
#  `rails generate hyrax:work GenericWork`
module Hyrax
  class GenericWorkPresenter < Hyku::WorkShowPresenter
    delegate :aark_id, :abstract, :date_issued, :alt, :part_of, :place_of_publication, :remote_url, to: :solr_document
  end
end
