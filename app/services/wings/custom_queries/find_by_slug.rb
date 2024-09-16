# frozen_string_literal: true

module Wings
  module CustomQueries
    class FindBySlug
      def self.queries
        [:find_by_slug]
      end

      def initialize(query_service:)
        @query_service = query_service
      end

      attr_reader :query_service
      delegate :resource_factory, to: :query_service

      def find_by_slug(slug:)
        ActiveFedora::Base.find(slug.to_s)&.valkyrie_resource
      rescue ActiveFedora::ObjectNotFoundError
        nil
      end
    end
  end
end
