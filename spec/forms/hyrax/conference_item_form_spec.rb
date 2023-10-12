# frozen_string_literal: true

# Generated via
#  `rails generate hyrax:work ConferenceItem`
require 'rails_helper'

RSpec.describe Hyrax::ConferenceItemForm do
  describe '.required_fields' do
    subject { described_class.required_fields }

    it { is_expected.to match_array [:rights_statement, :title] }
  end
end
