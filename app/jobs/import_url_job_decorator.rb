# frozen_string_literal: true

# OVERRIDE in v2.9.6 of Hyrax
module ImportUrlJobDecorator
  # OVERRIDE to gain further insight into the StandardError that was reported but hidden.
  def copy_remote_file(uri, name, headers = {})
    filename = File.basename(name)
    dir = Dir.mktmpdir
    Rails.logger.debug("ImportUrlJob: Copying <#{uri}> to #{dir}")

    File.open(File.join(dir, filename), 'wb') do |f|
      begin
        write_file(uri, f, headers)
        yield f
      rescue StandardError => e
        # OVERRIDE adding Rails.logger.error call
        Rails.logger.error(
          %(ImportUrlJob: Error copying <#{uri}> to #{dir} with #{e.message}.  #{e.backtrace.join("\n")})
        )
        send_error(e.message + e.backtrace.join("\n"))
        # TODO: Should we re-raise the exception?  As written this copy_remote_file has a false
        # success.
      end
    end
    Rails.logger.debug("ImportUrlJob: Copying <#{uri}> to #{dir}, closing #{File.join(dir, filename)}")
  end

  # OVERRIDE there are calls to send_error that send two arguments.
  # also give us the fileset with the error
  #
  # @see https://github.com/samvera/hyrax/blob/426575a9065a5dd3b30f458f5589a0a705ad7be2/app/jobs/import_url_job.rb#L76-L105
  def send_error(error_message, *)
    user = User.find_by_user_key(file_set.depositor)
    @file_set.errors.add("Error for file_set #{@file_set.id}:", error_message)
    Hyrax.config.callback.run(:after_import_url_failure, @file_set, user)
    @operation.fail!(@file_set.errors.full_messages.join(' '))
  end
end

ImportUrlJob.prepend(ImportUrlJobDecorator)
