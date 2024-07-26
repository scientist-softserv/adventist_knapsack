# frozen_string_literal: true

require 'frigg'

# override lib/valkyrie/persistence/postgres/query_service.rb
Valkyrie::Persistence::Postgres::QueryService.class_eval do
  def find_by(id:)
    result = self.custom_queries.find_by_slug(slug: id)
    return result if result

    # If not found, try by id
    id = Valkyrie::ID.new(id.to_s) if id.is_a?(String)
    validate_id(id)
    resource_factory.to_resource(object: orm_class.find(id.to_s))
  end
end

# override lib/wings/valkyrie/query_service.rb
#          This adds in find_by_slug, which uses the overridden ActiveFedora find
#          so it should always find without going to alternate_identifier
Wings::Valkyrie::QueryService.class_eval do
  def find_by(id:)
    self.custom_queries.find_by_slug(slug: id) || 
    self.find_by_alternate_identifier(alternate_identifier: id)
  end
end
