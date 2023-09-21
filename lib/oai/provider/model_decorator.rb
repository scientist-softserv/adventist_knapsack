# frozen_string_literal: true

module OAI
  module Provider
    module ModelDecorator
      # Map Qualified Dublin Core (Terms) fields to Oregon Digital fields
      def map_oai_qdc
        { title: :title,
          alternative: :alternative_title,
          description: :description,
          abstract: :abstract,
          identifier: :identifier,
          date: :date_created,
          created: :created,
          issued: :issued,
          creator: :creator,
          contributor: :contributor,
          subject: :subject,
          rights: :rights_statement,
          rightsHolder: :rights_holder,
          license: :license,
          publisher: :publisher,
          provenance: :provenance,
          spatial: :location,
          type: :type,
          language: :language,
          isPartOf: :is_part_of,
          tableOfContents: :table_of_contents,
          temporal: :temporal,
          bibliographicCitation: :citation,
          relation: :relation,
          isReferencedBy: :finding_aid,
          hasPart: :has_part,
          isVersionOf: :is_version_of,
          extent: :extent,
          format: :format,
          keyword: :keyword,
          location: :location,
          part: :part,
          volume: :volume }
      end

      # rubocop:disable Metrics/MethodLength
      def map_oai_adl
        {
          abstract: :abstract,
          alternative_title: :alternative_title,
          aark_d: :aark_id,
          bibliographic_citation: :bibliographic_citation,
          contributor: :contributor,
          created: :created,
          creator: :creator,
          date: :date_created,
          date_accepted: :date_accepted,
          date_issued: :date_issued,
          description: :description,
          edition: :edition,
          extent: :extent,
          geocode: :alt,
          has_part: :has_part,
          identifier: :identifier,
          is_version_of: :is_version_of,
          issue_number: :issue_number,
          language: :language,
          license: :license,
          location: :location,
          modified: :date_modified,
          pagination: :pagination,
          part_of: :part_of,
          place_of_publication: :place_of_publication,
          publisher: :publisher,
          relation: :relation,
          related_url: :related_url,
          remoteUrl: :remote_url,
          resource_type: :resource_type,
          rights_statement: :rights_statement,
          source: :source,
          subject: :subject,
          thumbnail_url: :thumbnail_url,
          title: :title,
          volume_number: :volume_number,
          work_type: :human_readable_type,
          keyword: :keyword,
          part: :part,
          volume: :volume
        }
      end
      # rubocop:enable Metrics/MethodLength
    end
  end
end
OAI::Provider::Model.prepend(OAI::Provider::ModelDecorator)
