# frozen_string_literal: true

class PackageIdsRenderer < Hyrax::Renderers::AttributeRenderer
  # Render the bibilionumber as a link to the King's Fund Library Catalogue record
  def attribute_value_to_html(value)
    object = ActiveFedora::Base.find(value)
    # rubocop:disable Rails/OutputSafety
    link_to(
      "<span class='glyphicon'></span>#{object.first_title}".html_safe,
      "/concern/#{object.class.to_s.pluralize.underscore}/#{value}"
    )
    # rubocop:enable Rails/OutputSafety
  end
end
