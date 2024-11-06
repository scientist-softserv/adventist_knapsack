Rails.application.config.to_prepare do
  WINGS_CONCERNS = [AdminSet, Collection, ConferenceItem, Dataset, Etd, ExamPaper, GenericWork, Image, JournalArticle, Oer, PublishedWork, Thesis].freeze
end
