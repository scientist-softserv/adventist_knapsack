# frozen_string_literal: true

## The purpose of this job is to take an array of collection ids and remove the
# membership relationshp from every work of a given work type. These are the 20
# collections that we were unable to delete, most likely due to too many members
# causing timeouts. Ref https://github.com/scientist-softserv/adventist-dl/issues/459
class CollectionMembershipJob < ApplicationJob
  queue_as :collections

  retry_on StandardError, attempts: 0

  # rubocop:disable Metrics/LineLength
  COLLECTIONS_TO_REMOVE = [
    "2487c594-1026-4a91-9ede-6105d5626a41", "67911ae1-8a26-4309-ba89-aca81c2fe3be", "4b298df0-9147-4990-a08d-0f53cbc90ed6", "be482035-fe21-4be0-9704-c422618b4525", "0c0444c4-9642-447d-b912-ae7de4163342", "a68b1cff-47c7-4f4d-9e1c-70c05ba48512", "608cca3c-9780-4842-b5f4-79bfcea8eb02", "36e07892-4167-4cb1-b0a8-986cfd1edbd6", "0b10fed9-51dd-48dd-89e1-dd990e94e1fc", "254bd824-7e53-400b-a74c-189043e02db8", "36b2f7ec-8750-482c-842c-bf02462fbf5b", "280c499e-7026-4427-b41b-1f594978cbf4", "2be7ac3e-786c-42f5-932b-180ac8ec5fee", "a5df1cbc-33eb-4120-ad93-b9d930a26dc7", "c1f28f13-0a97-42fe-b98e-52b14e26194c", "8647cc37-8434-4d9a-bb66-0d898715c264", "d44b5783-e949-40dd-b7fb-d1ed13cafc5f", "ac2a2de7-6aad-45f5-ab9f-0e7afb345855", "63daa10f-0ffa-4566-913c-f35eef9e077d", "07f8dbf8-06f2-472e-b11b-5efa21451e13"
  ].freeze
  # rubocop:enable Metrics/LineLength

  def perform(work_type: 'JournalArticle',
              removed_coll_ids: COLLECTIONS_TO_REMOVE)
    wk_count = 0
    wk_updated = 0

    # process all works of the given work_type
    work_type.constantize.find_each do |wk|
      wk_count += 1

      colls = wk.member_of_collection_ids
      new_colls = colls - removed_coll_ids
      next if colls == new_colls

      begin
        UpdateCollectionMembershipJob.perform_later(work_id: wk.id, colls: new_colls)
      rescue StandardError => e
        Rails.logger.error "👿👿 Error: #{e.message} for #{wk.id}"
        Raven.capture_exception(e)
        raise e
      end

      wk_updated += 1
    end

    # rubocop:disable Metrics/LineLength
    Rails.logger.info("💜💜💜 Collection updates for work type #{work_type}: #{wk_count} processed, #{wk_updated} updated.")
    # rubocop:enable Metrics/LineLength
  end
end
