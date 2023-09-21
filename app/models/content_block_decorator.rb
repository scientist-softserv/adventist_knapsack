# frozen_string_literal: true

module ContentBlockDecorator
end

ContentBlock::NAME_REGISTRY[:resources] = :resources_page
ContentBlock::NAME_REGISTRY[:homepage_about_section_heading] = :homepage_about_section_heading
ContentBlock::NAME_REGISTRY[:homepage_about_section_content] = :homepage_about_section_content
ContentBlock.prepend(ContentBlockDecorator)
