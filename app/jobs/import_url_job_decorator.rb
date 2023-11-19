# frozen_string_literal: true

# OVERRIDE in v3.5.0 of Hyrax
module ImportUrlJobDecorator
  # OVERRIDE to gain further insight into the StandardError that was reported but hidden.
  def copy_remote_file(name)
    filename = File.basename(name)
    dir = Dir.mktmpdir
    Rails.logger.debug("ImportUrlJob: Copying <#{uri}> to #{dir}")

    begin
      File.open(File.join(dir, filename), 'wb') do |f|
        write_file(f)
        yield f
      end
    rescue StandardError => e
      Rails.logger.error(
        %(ImportUrlJob: Error copying <#{uri}> to #{dir} with #{e.message}.  #{e.backtrace.join("\n")})
      )
      send_error(e.message)
      # TODO: Consider re-raising the exception if needed
    end
    Rails.logger.debug("ImportUrlJob: Closing #{File.join(dir, filename)}")
  end

  # OVERRIDE there are calls to send_error that send two arguments.
  #
  # @see https://github.com/samvera/hyrax/blob/426575a9065a5dd3b30f458f5589a0a705ad7be2/app/jobs/import_url_job.rb#L76-L105
  def send_error(error_message, *)
    super(error_message)
  end
end

ImportUrlJob.prepend(ImportUrlJobDecorator)
