# frozen_string_literal: true

# Generated via
#  `rails generate hyrax:work_resource ConferenceItemResource`
require 'rails_helper'
require 'hyrax/specs/shared_specs/hydra_works'

RSpec.describe ConferenceItemResource do
  subject(:work) { described_class.new }

  it_behaves_like 'a Hyrax::Work'
end
