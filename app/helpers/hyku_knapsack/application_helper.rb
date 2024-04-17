# frozen_string_literal: true

module HykuKnapsack
  module ApplicationHelper
    include ::DogBiscuitsHelper
    include IiifPrint::IiifPrintHelperBehavior
    include ::PdfJsHelper
    include ::FeaturesHelper

    def video_embed_viewer_display(work_presenter, locals = {})
      render video_embed_viewer_display_partial(work_presenter),
             locals.merge(presenter: work_presenter)
    end

    def video_embed_viewer_display_partial(work_presenter)
      'hyrax/base/' + work_presenter.video_embed_viewer.to_s
    end

    ##
    # This is in place to coerce the :q string to :query for passing the :q value to the query value
    # of a IIIF Print manifest.
    #
    # @param doc [SolrDocument]
    # @param request [ActionDispatch::Request]
    def generate_work_url(doc, request)
      url = super
      url = url.gsub('adventist-knapsack-staging.notch8.cloud/', 's2.adventistdigitallibrary.org/')
      return url if request.params[:q].blank?

      key = doc.any_highlighting? ? 'parent_query' : 'query'
      query = { key => request.params[:q] }.to_query
      if url.include?("?")
        url + "&#{query}"
      else
        url + "?#{query}"
      end
    end
  end

  # A Blacklight index field helper_method
  # @param [Hash] options from blacklight helper_method invocation. Maps rights statement URIs to links with labels.
  # @return [ActiveSupport::SafeBuffer] rights statement links, html_safe
  def rights_statement_links(options)
    service = Hyrax.config.rights_statement_service_class.new
    to_sentence(options[:value].map { |right| link_to service.label(right), right })
  rescue KeyError
    options[:value]
  end
end
