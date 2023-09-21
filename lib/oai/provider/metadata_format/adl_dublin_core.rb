# frozen_string_literal: true

module OAI
  module Provider
    module MetadataFormat
      class AdlDublinCore < OAI::Provider::Metadata::Format
        def initialize
          @prefix = 'oai_adl'
          @schema = 'http://dublincore.org/schemas/xmls/qdc/dcterms.xsd'
          @namespace = 'http://purl.org/dc/terms/'
          @element_namespace = 'dcterms'

          # Dublin Core Terms Fields
          # For new fields, add here first then add to oai_qdc_map
          @fields = %i[abstract alternative_title aark_id bibliographic_citation contributor created
                       creator date date_accepted date_issued description edition extent geocode
                       has_part identifier issue_number language license location modified
                       pagination part_of place_of_publication publisher related_url relation
                       remote_url resource_type rights_statement source subject title thumbnail_url
                       volume_number work_type]
        end

        # Override to strip namespace and header out
        def encode(model, record)
          xml = Builder::XmlMarkup.new
          map = model.respond_to?("map_#{prefix}") ? model.send("map_#{prefix}") : {}
          xml.tag!(prefix.to_s) do
            fields.each do |field|
              values = value_for(field, record, map)
              if values.respond_to?(:each)
                values.each do |value|
                  xml.tag! field.to_s, value
                end
              else
                xml.tag! field.to_s, values
              end
            end
          end
          xml.target!
        end

        def header_specification
          {
            'xmlns:oai_dc' => "http://www.openarchives.org/OAI/2.0/oai_dc/",
            'xmlns:oai_qdc' => "http://worldcat.org/xmlschemas/qdc-1.0/",
            'xmlns:oai_adl' => "http://worldcat.org/xmlschemas/qdc-1.0/",
            'xmlns:dc' => "http://purl.org/dc/elements/1.1/",
            'xmlns:dcterms' => "http://purl.org/dc/terms/",
            'xmlns:xsi' => "http://www.w3.org/2001/XMLSchema-instance",
            'xsi:schemaLocation' => "http://dublincore.org/schemas/xmls/qdc/dcterms.xsd"
          }
        end
      end
    end
  end
end
OAI::Provider::Base.register_format(OAI::Provider::MetadataFormat::AdlDublinCore.instance)
