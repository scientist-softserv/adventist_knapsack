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
        ActiveFedora::Base.find(slug).valkyrie_resource
      end
    end
  end
end
