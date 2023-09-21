# frozen_string_literal: true

class UpdateCollectionMembershipJob < ApplicationJob
  queue_as :collections

  retry_on StandardError, attempts: 0

  def perform(work_id:, colls:)
    wk = ActiveFedora::Base.find(work_id)
    new_colls_array = load_collections_for(colls)
    wk.member_of_collections = new_colls_array
    wk.save!
    Rails.logger.info("💯💯💯 Collections updated for #{wk.id}")
  end

  def load_collections_for(new_colls)
    ary = []

    new_colls.each do |id|
      coll = Collection.find(id)
      ary << coll
    end
    ary
  end
end
