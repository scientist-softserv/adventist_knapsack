# frozen_string_literal: true

require "spec_helper"
require "bulkrax/entry_spec_helper"

# rubocop:disable Metrics/LineLength
RSpec.describe Bulkrax::OaiAdventistQdcEntry do
  describe "#build_metadata" do
    subject(:entry) do
      Bulkrax::EntrySpecHelper.entry_for(
        entry_class: described_class,
        identifier: identifier,
        data: data,
        parser_class_name: "Bulkrax::OaiAdventistQdcParser",
        parser_fields: {
          "base_url" => "http://oai.adventistdigitallibrary.org/OAI-script"
        }
      )
    end

    let(:identifier) { "31290115" }
    let(:work_type) { PublishedWork }
    let(:data) do
      %(<?xml version="1.0" encoding="UTF-8"?>
        <OAI-PMH xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.openarchives.org/OAI/2.0/ http://www.openarchives.org/OAI/2.0/OAI-PMH.xsd">
        <responseDate>2023-02-01T20:41:11Z</responseDate>
        <request verb="GetRecord">http://oai.adventistdigitallibrary.org/OAI-script?identifier=#{identifier}&amp;metadataPrefix=oai_adl&amp;verb=GetRecord</request>
          <GetRecord>
          <record>
          <header>
          <identifier>#{identifier}</identifier>
            <datestamp>2022-12-15T05:09:20Z</datestamp>
            <setSpec>adl:book</setSpec>
            </header>
            <metadata>
            <oai_adl>
            <abstract>This tract is part of a series of testimonies written by Ellen White and published by the Seventh-day Adventist Church from 1855 to 1909.</abstract>
            <aark_id>#{identifier}</aark_id>
              <identifier>.b#{identifier}1</identifier>
                <creator>White, Ellen Gould Harmon, 1827-1915</creator>
                <title>Testimony for the Church: Number 7</title>
                <resource_type>Book</resource_type>
                <date_created>1862-01-01</date_created>
                <edition>Revised</edition>
                <language>English</language>
                <extent>no. in v. ; 15 cm.</extent>
                <source>Center for Adventist Research</source>
                <geocode>42.323991, -85.190425</geocode>
                <place_of_publication>Battle Creek, Michigan, USA</place_of_publication>
                <part_of>John N. Andrews Library Collection</part_of>
                <publisher>Steam Press of the Seventh-Day Adventist Publishing Association; Other Publisher</publisher>
                <rights_statement>No Copyright – United States</rights_statement>
                <subject>Charity -- Dress Reform -- Spiritualism; Civil War, 1861-1865 -- Slavery; History; Visions -- Censures; White, Ellen Gould Harmon, 1827-1915</subject>
                <pagination>[16]</pagination>
                <volume_number>178</volume_number>
                <peer_reviewed>Peer Reviewed</peer_reviewed>
                <location>Somewhere over the rainbow</location>
                <work_type>#{work_type}</work_type>
                  </oai_adl>
                  </metadata>
                  </record>
                  </GetRecord>
                  </OAI-PMH>)
    end

    # rubocop:disable RSpec/ExampleLength
    context 'for a Published Work' do
      let(:work_type) { PublishedWork }

      it "parses the metadata" do
        entry.build_metadata

        expect(entry.factory_class).to eq(work_type)
        expect(entry.parsed_metadata.fetch('title')).to eq(["Testimony for the Church: Number 7"])
        expect(entry.parsed_metadata.fetch('part')).to eq(["John N. Andrews Library Collection"])
        expect(entry.parsed_metadata.fetch('pagination')).to eq(["[16]"])
        expect(entry.parsed_metadata.fetch('volume_number')).to eq(["178"])
        expect(entry.parsed_metadata.fetch('location')).to eq(["Somewhere over the rainbow"])
        expect(entry.parsed_metadata.fetch('identifier')).to eq([identifier])
        expect(entry.parsed_metadata.fetch('edition')).to eq(["Revised"])
        expect(entry.parsed_metadata.fetch('refereed')).to eq(["Peer Reviewed"])

        expect(entry.parsed_metadata.fetch('publisher')).to eq(
          ["Steam Press of the Seventh-Day Adventist Publishing Association", "Other Publisher"]
        )
        expect(entry.parsed_metadata.fetch('subject')).to eq(
          [
            "Charity -- Dress Reform -- Spiritualism",
            "Civil War, 1861-1865 -- Slavery",
            "History", "Visions -- Censures",
            "White, Ellen Gould Harmon, 1827-1915"
          ]
        )
      end
    end
    # rubocop:enable RSpec/ExampleLength

    context 'for a Journal Article' do
      let(:work_type) { JournalArticle }

      it "parses the metadata" do
        entry.build_metadata

        expect(entry.factory_class).to eq(work_type)
        expect(entry.parsed_metadata.fetch('title')).to eq(["Testimony for the Church: Number 7"])
        expect(entry.parsed_metadata.fetch('part_of')).to eq(["John N. Andrews Library Collection"])
        expect(entry.parsed_metadata.fetch('pagination')).to eq(["[16]"])
        expect(entry.parsed_metadata.fetch('volume_number')).to eq(["178"])
        expect(entry.parsed_metadata.fetch('location')).to eq(["Somewhere over the rainbow"])
        expect(entry.parsed_metadata.fetch('identifier')).to eq([identifier])
        expect(entry.parsed_metadata.fetch('refereed')).to eq(["Peer Reviewed"])
      end
    end
  end
end
# rubocop:enable Metrics/LineLength
