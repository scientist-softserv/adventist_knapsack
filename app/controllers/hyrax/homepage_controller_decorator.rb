# frozen_string_literal: true

# OVERRIDE Hyku 5 to add homepage about blocks
module Hyrax
  module HomepageControllerDecorator

    def index
      # BEGIN copy Hyrax prime's Hyrax::HomepageController#index
      @presenter = presenter_class.new(current_ability, collections)
      @featured_researcher = ContentBlock.for(:researcher)
      @marketing_text = ContentBlock.for(:marketing)
      @featured_work_list = FeaturedWorkList.new
      @announcement_text = ContentBlock.for(:announcement)
      # OVERRIDE Hyku 5 to add homepage about blocks
      @homepage_about_section_heading = ContentBlock.for(:homepage_about_section_heading)
      @homepage_about_section_content = ContentBlock.for(:homepage_about_section_content)
      # END OVERRIDE
      
      recent
      # END copy

      # BEGIN OVERRIDE
      # What follows is Hyku specific overrides
      @home_text = ContentBlock.for(:home_text) # hyrax v3.5.0 added @home_text - Adding Themes
      @featured_collection_list = FeaturedCollectionList.new # OVERRIDE here to add featured collection list

      ir_counts if home_page_theme == 'institutional_repository'

      (@response, @document_list) = search_results(params)

      respond_to do |format|
        format.html { store_preferred_view }
        format.rss  { render layout: false }
        format.atom { render layout: false }
        format.json do
          @presenter = Blacklight::JsonPresenter.new(@response,
                                                     @document_list,
                                                     facets_from_request,
                                                     blacklight_config)
        end
        additional_response_formats(format)
        document_export_formats(format)
      end
    end


  end
end

Hyrax::HomepageController.prepend(Hyrax::HomepageControllerDecorator)
