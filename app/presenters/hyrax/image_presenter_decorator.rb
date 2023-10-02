# frozen_string_literal: true

Hyrax::ImagePresenter.delegate :aark_id,
                               :abstract,
                               :date_issued,
                               :alt,
                               :part_of,
                               :place_of_publication,
                               :remote_url, to: :solr_document
