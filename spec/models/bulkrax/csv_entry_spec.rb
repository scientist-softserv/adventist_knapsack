# frozen_string_literal: true

require "spec_helper"

module Bulkrax
  module SpecHelper
    ##
    # @api private
    #
    # A spec helper method for building Bulrax::Entry instances in downstream bulkrax applications.
    #
    # @params identifier [#to_s] The identifier of this object
    # @params data [String] The "data" value for the #raw_metadata of the {Bulkrax::Entry}.
    # @params parser_class_name [String] One of the the named parsers of {Bulkrax.parsers}
    # @params entry_class [Class<Bulkrax::Entry>]
    #
    # @return [Bulkrax::Entry]
    #
    # @todo Extract this method back into a Bulkrax::SpecHelper module.
    # @todo This could replace some of the factories in Bulkrax's spec suite.
    # @note This presently assumes as CSV oriented format; or "We haven't checked this against CSV".
    #       And the signature of this method should be considered volatile.
    def self.build_csv_entry_for(identifier:, data:, parser_class_name:, entry_class:)
      import_file_path = Rails.root.join("spec", "fixtures", "csv", "entry.csv")
      importer = Bulkrax::Importer.new(
        name: "Test importer for identifier #{identifier}",
        admin_set_id: "admin_set/default",
        user_id: 1,
        limit: 1,
        parser_klass: parser_class_name,
        field_mapping: Bulkrax.field_mappings.fetch(parser_class_name),
        parser_fields: { 'import_file_path' => import_file_path }
      )

      entry_class.new(
        importerexporter: importer,
        identifier: identifier,
        raw_metadata: data
      )
    end
  end
end

RSpec.describe Bulkrax::CsvEntry do
  describe "#build_metadata" do
    subject(:entry) do
      Bulkrax::SpecHelper.build_csv_entry_for(
        data: data,
        identifier: identifier,
        parser_class_name: 'Bulkrax::CsvParser',
        entry_class: described_class
      )
    end

    let(:identifier) { 'bl-26-0' }
    let(:data) do
      {
        "file".to_sym => "",
        "identifier".to_sym => %(P007204),
        "identifier.ark".to_sym => %(P007204),
        "title".to_sym => %(Village on a hillside in Tatsienlu, 1930s),
        "description".to_sym => %(Written on back: "A little cobblestone village on the side of a..."),
        "creator".to_sym => %(Andrews, John Nevins 1891-1980),
        "contributor".to_sym => "",
        "date".to_sym => %(1930),
        "date.other".to_sym => %(1930),
        "format.extent".to_sym => %(Photograph: b&w 7.7x10 cm),
        "type".to_sym => %(Image),
        "subject".to_sym => %(Andrews, John Nevins 1891-1980; Smith, John),
        "language".to_sym => "",
        "source".to_sym => %(Center for Adventist Research),
        "relation.isPartOf".to_sym => %(Center for Adventist Research Photograph Collection),
        "rights".to_sym => %(http://rightsstatements.org/vocab/NoC-US/1.0/),
        "coverage.spatial".to_sym => "",
        "publisher".to_sym => %(First Publisher; Second Publisher)
      }
    end

    it "assigns factory_class and parsed_metadata" do
      entry.build_metadata
      # Yes, based on the present parser, we're expecting this to be GenericWork.  However, there's
      # an outstanding question with the client as to whether that is the correct assumption.
      expect(entry.factory_class).to eq(GenericWork)
      expect(entry.parsed_metadata.fetch('subject')).to eq ["Andrews, John Nevins 1891-1980", "Smith, John"]
      expect(entry.parsed_metadata.fetch('publisher')).to eq ["First Publisher", "Second Publisher"]
      expect(entry.parsed_metadata.fetch('part_of')).to eq ["Center for Adventist Research Photograph Collection"]
    end
  end
end
