# frozen_string_literal: true

namespace :maintenance do
  desc "Index each tenants plain text files"
  task index_plain_text_file_content: :environment do
    Account.all.each do |account|
      IndexPlainTextFilesJob.perform_later(account)
    end
  end
end
