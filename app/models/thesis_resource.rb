# frozen_string_literal: true

# Generated via
#  `rails generate hyrax:work_resource ThesisResource`
class ThesisResource < Hyrax::Work
  include Hyrax::Schema(:basic_metadata)
  include Hyrax::Schema(:thesis_resource)
end
