# frozen_string_literal: true

# @api private
#
# This job is quite destructive; you'll want to read up on Bulkrax::RemoveAccountRelationshipsJob.
#
# It will break all of the relationships between works and collections that were part of every
# importer used by every account.  You almost certainly shouldn't do this in production.
#
# You will likely need to do this in development environments as you iterate on imports and such.
#
# To run you can use the command line:
#
#   rails runner "RemoveAccountRelationshipsJob.perform_later"
class RemoveAccountRelationshipsJob < ApplicationJob
  non_tenant_job

  class ForImporterJob < ApplicationJob
    def perform(account, importer_id)
      account.switch do
        importer = Bulkrax::Importer.find(importer_id)
        Bulkrax::RemoveRelationshipsForImporter.break_relationships_for!(importer: importer, with_progress_bar: false)
      end
    end
  end

  def perform(account)
    account.switch do
      Bulkrax::Importer.all.pluck(:id).each do |importer_id|
        ForImporterJob.perform_later(account, importer_id)
      end
    end
  end
end
