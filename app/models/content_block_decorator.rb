# frozen_string_literal: true

module ContentBlockDecorator
  NAME_REGISTRY = {
    marketing: :marketing_text,
    researcher: :featured_researcher,
    announcement: :announcement_text,
    about: :about_page,
    help: :help_page,
    terms: :terms_page,
    agreement: :agreement_page,
    home_text: :home_text,
    resources: :resources_page,
    homepage_about_section_heading: :homepage_about_section_heading,
    homepage_about_section_content: :homepage_about_section_content
  }.freeze
end

ContentBlock.prepend(ContentBlockDecorator)
