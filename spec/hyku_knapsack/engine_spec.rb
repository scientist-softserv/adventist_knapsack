# frozen_string_literal: true

require 'spec_helper'

RSpec.describe HykuKnapsack::Engine do
  describe 'I18n' do
    it 'has "en.dog_biscuits.fields.date_issued" key' do
      expect(I18n.t('dog_biscuits.fields.date_issued')).not_to start_with("Translation missing:")
      expect(I18n.t('dog_biscuits.fields.date_issued')).to eq("Date")
    end
  end
end
