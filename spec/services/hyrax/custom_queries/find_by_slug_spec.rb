# frozen_string_literal: true

RSpec.describe Wings::CustomQueries::FindBySlug do
  it 'is a registered custom query' do
    expect(Hyrax.query_service.services[0].custom_queries).to respond_to(:find_by_slug)
  end
end
