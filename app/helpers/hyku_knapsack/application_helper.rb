# frozen_string_literal: true

module HykuKnapsack
  module ApplicationHelper
    include IiifPrint::IiifPrintHelperBehavior
    include ::DogBiscuitsHelper
    include ::PdfJsHelper
    include ::FeaturesHelper

    def video_embed_viewer_display(work_presenter, locals = {})
      render video_embed_viewer_display_partial(work_presenter),
             locals.merge(presenter: work_presenter)
    end

    def video_embed_viewer_display_partial(work_presenter)
      'hyrax/base/' + work_presenter.video_embed_viewer.to_s
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
