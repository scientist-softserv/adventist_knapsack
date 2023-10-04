# frozen_string_literal: true

Hyrax::GenericWorkForm.terms += %i[
  aark_id
  alt
  bibliographic_citation
  date_issued
  part_of
  place_of_publication
  remote_url
  video_embed
]
Hyrax::GenericWorkForm.terms -= %i[alternative_title]
