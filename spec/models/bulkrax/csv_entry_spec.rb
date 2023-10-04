# frozen_string_literal: true

require "spec_helper"

require 'bulkrax/entry_spec_helper.rb'

RSpec.describe Bulkrax::CsvEntry do
  describe "#build_metadata" do
    subject(:entry) do
      Bulkrax::EntrySpecHelper.entry_for(
        data: data,
        identifier: identifier,
        parser_class_name: 'Bulkrax::CsvParser',
        parser_fields: { 'import_file_path' => "spec/fixtures/csv/entry.csv" }
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
