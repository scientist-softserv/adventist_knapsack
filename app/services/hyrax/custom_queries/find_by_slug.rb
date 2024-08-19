# frozen_string_literal: true

module Hyrax
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
        Hyrax.query_service.orm_class.find_by_sql([find_by_slug_query, "\"#{slug}\""]).lazy.map do |object|
          resource_factory.to_resource(object:)
        end.first
      end

      def find_by_slug_query
        <<-SQL
          SELECT * FROM orm_resources
          WHERE (metadata -> 'slug' @> ?)
        SQL
      end
    end
  end
end
