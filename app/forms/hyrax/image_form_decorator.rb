# frozen_string_literal: true

Hyrax::ImageForm.terms += %i[
  aark_id
  alt
  bibliographic_citation
  date_issued
  part_of
  place_of_publication
  remote_url
]
Hyrax::ImageForm.terms -= %i[alternative_title]
