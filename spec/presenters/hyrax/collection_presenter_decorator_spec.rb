# frozen_string_literal: true

require 'spec_helper'
require 'shoulda/matchers'

RSpec.describe Hyrax::CollectionPresenter do
  let(:document) { SolrDocument.new(official_url_tesim: 'https://samvera.org') }

  describe '.terms' do
    it 'includes the Collect.additional_terms' do
      expect(Collection.additional_terms & described_class.terms).to eq(Collection.additional_terms)
    end
  end

  describe 'delegation' do
    subject { described_class.new(double(SolrDocument), nil) }

    Collection.additional_terms.each do |term|
      it { is_expected.to delegate_method(term).to(:solr_document) }
    end
  end

  describe '#terms_with_values' do
    let(:instance) { described_class.new(document, nil) }

    # TODO: this spec fails because Hyku has an override by the same name
    xit 'includes values from collection' do
      expect(instance.terms_with_values).to include(:official_url) # Which is a collection property.
    end
  end
end
