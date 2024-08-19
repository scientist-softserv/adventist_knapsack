# frozen_string_literal: true

require 'spec_helper'

# rubocop:disable RSpec/DescribeClass
RSpec.describe "Slug Override" do
  # TODO: update to valkyrie - we don't care about fedora records anymore
  describe "Fedora records" do
    let(:work) { FactoryBot.create(:generic_work, aark_id: 'something') }
    let(:transactions) { Hyrax::Transactions::Container }
    let(:current_user) { User.find_by(email: work.depositor) }

    # The following logic duplicates the batch delete found here:
    # https://github.com/samvera/hyrax/blob/b334e186e77691d7da8ed59ff27f091be1c2a700/app/controllers/hyrax/batch_edits_controller.rb#L88-L97
    xit 'deletes via Hyrax::Transactions' do
      doc_id = work.to_param

      # rubocop:disable Layout/LineLength
      expect do
        resource = Hyrax.query_service.find_by(id: Valkyrie::ID.new(doc_id))
        transactions['collection_resource.destroy']
          .with_step_args('collection_resource.delete' => { user: current_user })
          .call(resource)
          .value!
      end.to change { ActiveFedora::SolrService.query("id:\"#{doc_id}\"", fl: "id", method: :post, rows: 1).count }.from(1).to(0)
      # rubocop:enable Layout/LineLength
    end
  end
end
# rubocop:enable RSpec/DescribeClass
