# frozen_string_literal: true

# OVERRIDE Hyrax 3.6 to add custom default thumbnails

module Hyrax
  module Actors
    module CreateWithRemoteFilesActorDecorator
      module IngestRemoteFilesServiceDecorator
        ##
        # @return true
        # rubocop:disable Metrics/MethodLength
        def attach!
          return true unless remote_files
          remote_files.each do |file_info|
            next if file_info.blank? || file_info[:url].blank?
            # Escape any space characters, so that this is a legal URI
            uri = URI.parse(Addressable::URI.escape(file_info[:url]))
            unless self.class.validate_remote_url(uri)
              msg = "User #{user.user_key} attempted to ingest file from url #{file_info[:url]}"
              msg += ", which doesn't pass validation"
              Rails.logger.error msg
              return false
            end
            auth_header = file_info.fetch(:auth_header, {})
            # OVERRIDE Hyrax 3.5 to override default_thumbnail
            create_file_from_url(uri, file_info[:file_name], auth_header, file_info[:default_thumbnail])
          end
          add_ordered_members! if ordered
          true
        end
        # rubocop:enable Layout/LineLength

        def create_file_from_url(uri, file_name, auth_header, override_default_thumbnail = nil)
          import_url = URI.decode_www_form_component(uri.to_s)
          use_valkyrie = false
          case curation_concern
          when Valkyrie::Resource
            file_set = Hyrax.persister.save(resource: Hyrax::FileSet.new(import_url:, label: file_name))
            use_valkyrie = true
          else
            # OVERRIDE Hyrax 3.5 to override default_thumbnail
            file_set = ::FileSet.new(import_url:,
                                     label: file_name,
                                     override_default_thumbnail:)
          end
          __create_file_from_url(file_set:, uri:, auth_header:, use_valkyrie:)
        end
      end
    end
  end
end

# rubocop:disable Layout/LineLength
Hyrax::Actors::CreateWithRemoteFilesActor::IngestRemoteFilesService.prepend Hyrax::Actors::CreateWithRemoteFilesActorDecorator::IngestRemoteFilesServiceDecorator
# rubocop:enable Layout/LineLength
