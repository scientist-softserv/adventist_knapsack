# frozen_string_literal: true

require 'spec_helper'

RSpec.describe IiifPrint do
  describe '.config' do
    describe '.unique_child_title_generator_function' do
      subject { described_class.config.unique_child_title_generator_function }

      it 'is defined in HykuKnapsack::Engine' do
        # Verifying that we're using the configured title generator for PDFs.
        # Triage for: https://github.com/scientist-softserv/adventist-dl/issues/628
        expect(subject.source_location[0]).to(
          eq(HykuKnapsack::Engine.root.join('config', 'initializers', 'iiif_print.rb').to_s)
        )
      end
    end
    describe '.sort_iiif_manifest_canvases_by' do
      it do
        # require 'byebug'; byebug
      end
    end
  end

  describe 'decoration of Hyrax::ManifestBuilderService' do
    describe '#manifest_for method' do
      subject { Hyrax::ManifestBuilderService.instance_method(:manifest_for).source_location[0] }

      # Verifying that we're using the IIIF Print provided source_location; in particular we're not
      # using the undecorated Hyrax version.
      it { is_expected.to start_with(IiifPrint::Engine.root.to_s) }
    end

    describe '#build_manifest' do
      subject { Hyrax::ManifestBuilderService.instance_method(:build_manifest).source_location[0] }

      it do
        is_expected.to(
          eq(HykuKnapsack::Engine.root.join('app', 'services', 'iiif_print', 'manifest_builder_service_behavior_decorator.rb').to_s)
        )
      end
    end
  end
end
