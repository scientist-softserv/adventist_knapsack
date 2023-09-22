# frozen_string_literal: true

require "spec_helper"
require "bulkrax/entry_spec_helper"

RSpec.describe Bulkrax::OaiAdventistSetEntry do
  describe "#build_metadata" do
    subject(:entry) do
      Bulkrax::EntrySpecHelper.entry_for(
        entry_class: described_class,
        identifier: identifier,
        data: data,
        parser_class_name: "Bulkrax::OaiAdventistQdcParser"
      )
    end

    let(:identifier) { "20000026" }
    let(:collection_title) { "Rumah Tangga Dan Kesehatan" }
    # rubocop:disable Metrics/LineLength
    let(:data) do
      %(<?xml version="1.0" encoding="UTF-8"?>
        <OAI-PMH xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.openarchives.org/OAI/2.0/ http://www.openarchives.org/OAI/2.0/OAI-PMH.xsd">
          <responseDate>2023-02-01T20:41:11Z</responseDate>
          <request verb="GetRecord">http://oai.adventistdigitallibrary.org/OAI-script?identifier=#{identifier}&amp;metadataPrefix=oai_adl&amp;verb=GetRecord</request>
          <GetRecord>
            <record>
            <header>
              <identifier>#{identifier}</identifier> <datestamp>2022-12-15T05:09:20Z</datestamp> <setSpec>adl:periodical</setSpec>
            </header>
            <metadata><oai_adl>
              <aark_id>#{identifier}</aark_id><title>Pertandaan Zaman</title><resource_type>Periodical</resource_type><date_created>1901-01-01</date_created><language>Malay</language><extent>v. illus. 4to and fol.</extent><source>Center for Adventist Research</source><place_of_publication>Singapore</place_of_publication><publisher>The Signs Press</publisher><rights_statement>No Copyright - United States</rights_statement><part_of>#{collection_title}</part_of><work_type>Collection</work_type>
            </oai_adl></metadata>
            </record>
          </GetRecord>
        </OAI-PMH>)
    end

    # rubocop:enable Metrics/LineLength
    it "does not set a pending relationship for the part_of collection" do
      # This needs to be persisted for saving the entry
      entry.importer.save!
      entry.importer.importer_runs.create!
      entry.save!

      # We have disabled
      expect { entry.build }.not_to change(Bulkrax::PendingRelationship, :count)
    end
  end
end
