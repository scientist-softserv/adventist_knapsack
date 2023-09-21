# frozen_string_literal: true

RSpec.describe '/concern/generic_works routing', clean: true do
  let(:work) { create(:generic_work) }

  context 'without AARK ID' do
    it "routes to work by UUID" do
      expect(get: "/concern/generic_works/#{work.id}")
        .to route_to(controller: 'hyrax/generic_works', action: 'show', id: work.id.to_s)
    end
  end

  context 'with AARK ID' do
    it "routes to work by UUID" do
      work.aark_id = "3456789123"
      work.save
      expect(get: "/concern/generic_works/#{work.id}")
        .to route_to(controller: 'hyrax/generic_works', action: 'show', id: work.id.to_s)
    end

    it "routes to work by AARK ID and title" do
      expect(get: "/concern/generic_works/3456789123_test_title")
        .to route_to(controller: 'hyrax/generic_works', action: 'show', id: "3456789123_test_title")
    end
  end
end
