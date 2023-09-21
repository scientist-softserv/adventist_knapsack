# frozen_string_literal: true

RSpec.describe Bulkrax do
  describe ".parsers" do
    subject(:parsers) { described_class.parsers }

    it "is limited to Bulkrax::OaiAdventistQdcParser and Bulkrax::CsvParser" do
      expect(parsers.map { |parser| parser.fetch(:class_name) })
        .to match_array(["Bulkrax::OaiAdventistQdcParser", "Bulkrax::CsvParser"])
    end
  end
end
