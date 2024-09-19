# frozen_string_literal: true
# Override Hyku 5.0.1

module Hyku
  module WorkShowPresenterDecorator
    # Supports varying label on show page attributes by class
    def part_of_label
      klass = model_klass
      klass == JournalArticle ? 'Periodical' : 'Part Of'
    end

    # OVERRIDE incorporates fallback to PDF.js viewer via fileset's import_url
    # see also pdf_js_helper_decorator
    def show_pdf_viewer?
      return unless Flipflop.default_pdf_viewer? || !iiif_viewer?
      return unless file_set_presenters.any?(&:pdf?) || pdf_extension?

      no_child_works?
    end

    # OVERRIDE Hyku TenantConfig
    # @return [Boolean] render a IIIF viewer
    def iiif_viewer?
      no_children = no_child_works?
      # Fall back to PDFjs viewer if we have a pdf that hasn't been split
      return false if no_children && (file_set_presenters.any?(&:pdf?) || pdf_extension?)
      # Fallback to UV even if PDFjs flag is on, as long as PDF has been split
      Hyrax.config.iiif_image_server? &&
        representative_id.present? &&
        representative_presenter.present? &&
        members_include_iiif_viewable? &&
        (iiif_media? || !no_children)
    end

    # Returns true if all of the member_presenters are file_set presenters
    def no_child_works?
      member_presenters.all? { |presenter| presenter.is_a? Hyrax::FileSetPresenter }
    end

    def pdf_extension?
      file_set_presenters.any? { |fsp| fsp&.label&.downcase&.end_with?('.pdf') }
    end

    def iiif_media?(presenter: representative_presenter)
      iiif_media_predicates.any? { |predicate| presenter.try(predicate) || presenter.try(:solr_document).try(predicate) }
    end

    # Override Tenant Config
    def members_include_iiif_viewable?
      iiif_presentable_member_presenters.any? do |presenter|
        iiif_media?(presenter:) && current_ability.can?(:read, presenter.id)
      end
    end

    private

    def model_klass
      model_name.instance_variable_get(:@klass)
    end
  end
end

Hyku::WorkShowPresenter.prepend Hyku::WorkShowPresenterDecorator
Hyku::WorkShowPresenter.delegate :bibliographic_citation, :alt, to: :solr_document
