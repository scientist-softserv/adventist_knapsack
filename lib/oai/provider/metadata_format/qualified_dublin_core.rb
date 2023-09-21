# frozen_string_literal: true

module OAI
  module Provider
    module MetadataFormat
      class QualifiedDublinCore < OAI::Provider::Metadata::Format
        def initialize
          @prefix = 'oai_qdc'
          @schema = 'http://dublincore.org/schemas/xmls/qdc/dcterms.xsd'
          @namespace = 'http://purl.org/dc/terms/'
          @element_namespace = 'dcterms'

          # Dublin Core Terms Fields
          # For new fields, add here first then add to oai_qdc_map
          @fields = %i[title alternative description abstract identifier date created issued
                       creator contributor subject type rights rightsHolder license publisher provenance
                       spatial language isPartOf tableOfContents temporal bibliographicCitation relation
                       isReferencedBy hasPart isVersionOf extent format]
        end

        def header_specification
          {
            'xmlns:oai_dc' => "http://www.openarchives.org/OAI/2.0/oai_dc/",
            'xmlns:oai_qdc' => "http://worldcat.org/xmlschemas/qdc-1.0/",
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
OAI::Provider::Base.register_format(OAI::Provider::MetadataFormat::QualifiedDublinCore.instance)
