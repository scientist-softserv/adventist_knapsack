# frozen_string_literal: true

# OVERRIDE to add adventist's custom colors and fonts
module Hyrax
  module Forms
    module Admin
      module AdlAppearanceDecorator
        DEFAULT_COLORS = {
          'custom_adl_header_footer_color'     => '#CE8C00',
          'header_and_footer_background_color' => '#000000',
          'header_and_footer_text_color'       => '#2C2C2C',
          'navbar_background_color'            => '#000000',
          'navbar_link_background_hover_color' => '#000000',
          'navbar_link_text_color'             => '#2C2C2C',
          'navbar_link_text_hover_color'       => '#FFFFFF',
          'link_color'                         => '#985F03',
          'link_hover_color'                   => '#FFBD42',
          'footer_link_color'                  => '#985F03',
          'footer_link_hover_color'            => '#000000',
          'primary_button_hover_color'         => '#CE8C00',
          'default_button_background_color'    => '#ffffff',
          'default_button_border_color'        => '#5B5B5B',
          'default_button_text_color'          => '#FFFFFF',
          'active_tabs_background_color'       => '#FFFFFF',
          'facet_panel_background_color'       => '#000000',
          'facet_panel_text_color'             => '#FFFFFF'
        }.freeze

        DEFAULT_FONTS = {
          'body_font'     => 'Helvetica Neue, Helvetica, Arial, sans-serif;',
          'headline_font' => 'Helvetica Neue, Helvetica, Arial, sans-serif;'
        }.freeze

        def custom_adl_header_footer_color
          block_for('custom_adl_header_footer_color')
        end
      end
    end
  end
end

Hyrax::Forms::Admin::Appearance.prepend Hyrax::Forms::Admin::AdlAppearanceDecorator

Hyku::Forms::Admin::Appearance.customization_params << :custom_adl_header_footer_color
