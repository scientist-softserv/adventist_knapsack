# frozen_string_literal: true

require 'spec_helper'

RSpec.describe HykuKnapsack::Engine do
  describe 'I18n' do
    it 'has "en.dog_biscuits.fields.date_issued" key' do
      expect(I18n.t('dog_biscuits.fields.date_issued')).not_to start_with("Translation missing:")
      expect(I18n.t('dog_biscuits.fields.date_issued')).to eq("Date")
    end
  end

  describe 'view_paths' do
    it 'has HykuKnapsack::Engine path before IIIF Print which is before Hyku' do
      paths = ApplicationController.view_paths.map(&:to_s)
      knapsack = paths.index(HykuKnapsack::Engine.root.join('app', 'views').to_s)
      iiif_print = paths.index(IiifPrint::Engine.root.join('app', 'views').to_s)
      hyku = paths.index(Rails.root.join('app', 'views').to_s)

      # An earlier index means that it's picked up as the first candidate for choosing a view.
      expect(knapsack).to be < iiif_print
      expect(knapsack).to be < hyku
      expect(iiif_print).to be < hyku
    end
  end
end
