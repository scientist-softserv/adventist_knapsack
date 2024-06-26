# frozen_string_literal: true

# Use this to override any Hyrax configuration from the Knapsack
Hyrax.config do |config|
  # Injected via `rails g hyrax:work ConferenceItem`
  config.register_curation_concern :conference_item
  # Injected via `rails g hyrax:work Dataset`
  config.register_curation_concern :dataset
  # Injected via `rails g hyrax:work ExamPaper`
  config.register_curation_concern :exam_paper
  # Injected via `rails g hyrax:work JournalArticle`
  config.register_curation_concern :journal_article
  # Injected via `rails g hyrax:work PublishedWork`
  config.register_curation_concern :published_work
  # Injected via `rails g hyrax:work Thesis`
  config.register_curation_concern :thesis

  # See https://github.com/scientist-softserv/adventist-dl/issues/183
  # Also, we will continue to extract txt file's text using Adventist::TextFileTextExtractionService
  config.extract_full_text = false
  config.work_requires_files = false

  # Location autocomplete uses geonames to search for named regions.
  # Specify the user for connecting to geonames:
  # Register here: http://www.geonames.org/manageaccount
  config.geonames_username = ENV.fetch('HYKU_GEONAMES_USERNAME', 'jcoyne')
  # If you have ffmpeg installed and want to transcode audio and video uncomment this line
  config.enable_ffmpeg = false

  config.branding_path = ENV.fetch('HYRAX_BRANDING_PATH', Rails.root.join('public', 'branding'))
  config.nested_relationship_reindexer = ->(id:, extent:) {}
end
