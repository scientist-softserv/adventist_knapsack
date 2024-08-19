# frozen_string_literal: true

# OVERRIDE Hyrax 3.5.0 to override default_thumbnail

module Hyrax
  module Actors
    module FileSetActorDecorator
      # rubocop:disable Metrics/AbcSize
      def attach_to_valkyrie_work(work, file_set_params)
        work = Hyrax.query_service.find_by(id: work.id) unless work.new_record
        file_set.visibility = work.visibility unless assign_visibility?(file_set_params)
        fs = Hyrax.persister.save(resource: file_set)
        Hyrax.publisher.publish('object.metadata.updated', object: fs, user:)
        work.member_ids << fs.id
        work.representative_id = fs.id if work.representative_id.blank?
        # OVERRIDE Hyrax 3.5.0 to override default_thumbnail
        work.thumbnail = file_set if file_set.override_default_thumbnail == 'true' || work.thumbnail_id.blank?

        # Save the work so the association between the work and the file_set is persisted (head_id)
        # NOTE: the work may not be valid, in which case this save doesn't do anything.
        Hyrax.persister.save(resource: work)
        Hyrax.publisher.publish('object.metadata.updated', object: work, user:)
      end
      # rubocop:enable Metrics/AbcSize

      # Adds a FileSet to the work using ore:Aggregations.
      def attach_to_af_work(work, file_set_params)
        work.reload unless work.new_record?
        file_set.visibility = work.visibility unless assign_visibility?(file_set_params)
        work.ordered_members << file_set
        work.representative = file_set if work.representative_id.blank?
        # OVERRIDE Hyrax 3.5.0 to override default_thumbnail
        work.thumbnail = file_set if file_set.override_default_thumbnail == 'true' || work.thumbnail_id.blank?

        # Save the work so the association between the work and the file_set is persisted (head_id)
        # NOTE: the work may not be valid, in which case this save doesn't do anything.
        work.save
      end
    end
  end
end

Hyrax::Actors::FileSetActor.prepend Hyrax::Actors::FileSetActorDecorator
