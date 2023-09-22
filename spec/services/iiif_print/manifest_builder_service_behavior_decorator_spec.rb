# frozen_string_literal: true

require 'spec_helper'

# rubocop:disable RSpec/FilePath, Metrics/LineLength
RSpec.describe IiifPrint::IiifManifestPresenterBehavior do
  let(:presenter) { double(Hyrax::IiifManifestPresenter) }
  let(:solr_doc_hits) { [double("SolrHit")] }

  describe '#sanitize_v2' do
    context 'when thumbnail files are present' do
      let(:service) { Hyrax::ManifestBuilderService.new }
      # TODO: REFACTOR!
      let(:manifest_w_thumbnail_hash) do
        {
          "@context" => "http://iiif.io/api/presentation/2/context.json",
          "@type" => "sc:Manifest",
          "@id" => "http://dev.hyku.test/concern/published_works/20000230_seventh_day_adventist_yearbook/manifest",
          "label" => "Seventh-day Adventist Yearbook",
          "description" => "Suspended 1895-1903",
          "metadata" => [
            {
              "label" => "Title",
              "value" => [
                "Seventh-day Adventist Yearbook"
              ]
            },
            {
              "label" => "Description",
              "value" => [
                "Suspended 1895-1903"
              ]
            },
            {
              "label" => "Date modified",
              "value" => [
                "04/03/2023"
              ]
            },
            {
              "label" => "Publisher",
              "value" => [
                "<a href='http://dev.hyku.test/catalog?f%5Bpublisher_sim%5D%5B%5D=Office+of+Archives%2C+Statistics%2C+and+Research&locale=en'>Office of Archives, Statistics, and Research</a>",
                "<a href='http://dev.hyku.test/catalog?f%5Bpublisher_sim%5D%5B%5D=Review+and+Herald+Publishing+Association&locale=en'>Review and Herald Publishing Association</a>"
              ]
            },
            {
              "label" => "Language",
              "value" => [
                "<a href='http://dev.hyku.test/catalog?f%5Blanguage_sim%5D%5B%5D=English&locale=en'>English</a>"
              ]
            },
            {
              "label" => "Identifier",
              "value" => [
                "20000230"
              ]
            },
            {
              "label" => "Date created",
              "value" => [
                "1883-01-01"
              ]
            },
            {
              "label" => "Resource type",
              "value" => [
                "<a href='http://dev.hyku.test/catalog?f%5Bresource_type_sim%5D%5B%5D=Yearbook&locale=en'>Yearbook</a>"
              ]
            },
            {
              "label" => "Source",
              "value" => [
                "Center for Adventist Research"
              ]
            },
            {
              "label" => "Extent",
              "value" => [
                "23 cm.",
                "v."
              ]
            },
            {
              "label" => "Rights statement",
              "value" => [
                "<a href=''></a>"
              ]
            }
          ],
          "service" => [
            {
              "@context" => "http://iiif.io/api/search/0/context.json",
              "profile" => "http://iiif.io/api/search/0/search",
              "label" => "Search within this manifest",
              "@id" => "http://dev.hyku.test/catalog/20000230_seventh_day_adventist_yearbook/iiif_search"
            }
          ],
          "sequences" => [
            {
              "@type" => "sc:Sequence",
              "@id" => "http://dev.hyku.test/concern/published_works/20000230_seventh_day_adventist_yearbook/manifest/sequence/normal",
              "rendering" => [],
              "canvases" => [
                {
                  "@type" => "sc:Canvas",
                  "@id" => "http://dev.hyku.test/concern/published_works/20000230_seventh_day_adventist_yearbook/manifest/canvas/1bb00851-4f0f-4a32-9512-7dc6241ecad6",
                  "label" => "20000230.OBJ.jpg",
                  "width" => 600,
                  "height" => 775,
                  "images" => [
                    {
                      "@type" => "oa:Annotation",
                      "motivation" => "sc:painting",
                      "resource" => {
                        "@type" => "dctypes:Image",
                        "@id" => "http://dev.hyku.test/images/1bb00851-4f0f-4a32-9512-7dc6241ecad6%2Ffiles%2F286d5934-475a-4de7-989b-569b69faed8c%2Ffcr:versions%2Fversion1/full/600,/0/default.jpg",
                        "height" => 775,
                        "width" => 600,
                        "format" => "jpg",
                        "service" => {
                          "@context" => "http://iiif.io/api/image/2/context.json",
                          "@id" => "http://dev.hyku.test/images/1bb00851-4f0f-4a32-9512-7dc6241ecad6%2Ffiles%2F286d5934-475a-4de7-989b-569b69faed8c%2Ffcr:versions%2Fversion1",
                          "profile" => "http://iiif.io/api/image/2/level2.json"
                        }
                      },
                      "on" => "http://dev.hyku.test/concern/published_works/20000230_seventh_day_adventist_yearbook/manifest/canvas/1bb00851-4f0f-4a32-9512-7dc6241ecad6"
                    }
                  ]
                },
                {
                  "@type" => "sc:Canvas",
                  "@id" => "http://dev.hyku.test/concern/published_works/20000230_seventh_day_adventist_yearbook/manifest/canvas/d53ed357-f581-4b1c-96a8-0ed3cda3d040",
                  "label" => "20000230.TN.jpg",
                  "width" => 600,
                  "height" => 775,
                  "images" => [
                    {
                      "@type" => "oa:Annotation",
                      "motivation" => "sc:painting",
                      "resource" => {
                        "@type" => "dctypes:Image",
                        "@id" => "http://dev.hyku.test/images/d53ed357-f581-4b1c-96a8-0ed3cda3d040%2Ffiles%2F50f6d058-f353-453b-b7ab-64146d8469e9%2Ffcr:versions%2Fversion1/full/600,/0/default.jpg",
                        "height" => 775,
                        "width" => 600,
                        "format" => "jpg",
                        "service" => {
                          "@context" => "http://iiif.io/api/image/2/context.json",
                          "@id" => "http://dev.hyku.test/images/d53ed357-f581-4b1c-96a8-0ed3cda3d040%2Ffiles%2F50f6d058-f353-453b-b7ab-64146d8469e9%2Ffcr:versions%2Fversion1",
                          "profile" => "http://iiif.io/api/image/2/level2.json"
                        }
                      },
                      "on" => "http://dev.hyku.test/concern/published_works/20000230_seventh_day_adventist_yearbook/manifest/canvas/d53ed357-f581-4b1c-96a8-0ed3cda3d040"
                    }
                  ]
                }
              ]
            }
          ]
        }
      end

      before { allow(service).to receive(:apply_metadata_to_canvas) }

      it 'does not include thumbnail files in the returned hash' do
        expect(service.sanitize_v2(hash: manifest_w_thumbnail_hash, presenter: presenter, solr_doc_hits: solr_doc_hits)['sequences'].first['canvases'].pluck('label')).not_to include("20000230.TN.jpg")
        expect(service.sanitize_v2(hash: manifest_w_thumbnail_hash, presenter: presenter, solr_doc_hits: solr_doc_hits)['sequences'].first['canvases'].pluck('label')).to include("20000230.OBJ.jpg")
      end
    end
  end
end
# rubocop:enable RSpec/FilePath, Metrics/LineLength
