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
end
