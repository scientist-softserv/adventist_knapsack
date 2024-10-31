# frozen_string_literal: true

require 'spec_helper'

RSpec.describe HykuKnapsack::ApplicationHelper do
  let(:helper) { _view }

  let(:cname) { 'hyku-me.test' }
  let(:account) { build(:search_only_account, cname:) }

  let(:uuid) { SecureRandom.uuid }
  let(:request) do
    instance_double(ActionDispatch::Request,
                    port: 3000,
                    protocol: "https://",
                    host: account.cname,
                    params: { q: })
  end
  let(:doc) { SolrDocument.new(id: uuid, 'has_model_ssim': ['GenericWork'], 'account_cname_tesim': account.cname) }

  before do
    allow(helper).to receive(:current_account) { account }
  end
end
