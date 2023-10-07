# frozen_string_literal: true

require 'spec_helper'

RSpec.describe HykuKnapsack::Engine do
  describe 'I18n.load_path' do
    it 'has HykuKnapsack translations at a higher precendence than Hyku translations' do
      hyku_root = Rails.root.to_s
      knappy_root = described_class.root.to_s

      highest_precedence_knappy = nil
      highest_precedence_hyku = nil

      # We need to reverse the load_path as later entries in the load path take precedence over
      # earlier entries in the array.
      I18n.load_path.reverse.each_with_index do |path, index|
        if !highest_precedence_hyku && path.start_with?(hyku_root)
          highest_precedence_hyku = index
        elsif !highest_precedence_knappy && path.start_with?(knappy_root)
          highest_precedence_knappy = index
        end
        break if highest_precedence_knappy && highest_precedence_hyku
      end

      # The first encountered translation for knappy happens before the first encountered hyku
      # translation; meaning that knappy's translations are of higher precedence.
      expect(highest_precedence_knappy).to be < highest_precedence_hyku
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
