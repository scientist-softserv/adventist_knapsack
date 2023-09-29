# frozen_string_literal: true

# OVERRIDE to add adventist's custom colors and fonts
module Hyrax
  module Forms
    module Admin
      module AppearanceDecorator
        ADL_DEFAULT_COLORS = {
          'custom_adl_header_footer_color'        => '#CE8C00',
          'header_background_color'               => '#000000',
          'active_tabs_background_color'          => '#3c3c3c',
          'header_background_border_color'       => '#000000',
          'header_text_color'                     => '#2C2C2C',
          # 'navbar_background_color'             => '#ffffff',
          # 'navbar_link_background_hover_color'  => '#ffffff',
          # 'navbar_link_text_color'              => '#eeeeee',
          # 'navbar_link_text_hover_color'        => '#eeeeee',
          'link_color'                            => '#2e74b2',
          'link_hover_color'                      => '#215480',
          'footer_link_color'                     => '#ffebcd',
          'footer_link_hover_color'               => '#ffffff',
          'primary_button_background_color'       => '#CE8C00',
          'primary_button_border_color'           => '#CE8C00',
          'primary_button_focus_background_color' => '#CE8C00',
          'primary_button_focus_border_color'     => '#CE8C00',
          'primary_button_hover_background_color' => '#286090',
          'primary_button_hover_border_color'     => '#286090',
          'default_button_background_color'       => '#ffffff',
          'default_button_border_color'           => '#cccccc',
          'default_button_text_color'             => '#333333',
          'default_button_focus_background_color' => '#333333',
          'default_button_focus_border_color'     => '#333333',
          'default_button_hover_background_color' => '#333333',
          'default_button_hover_border_color'     => '#333333',
          'default_button_text_color'             => '#333333',
          'active_tabs_background_color'          => '#337ab7',
          'facet_panel_background_color'          => '#f5f5f5',
          'facet_panel_text_color'                => '#333333',
          'facet_panel_border_color'              => '#f5f5f5'
        }.freeze

        ADL_DEFAULT_FONTS = {
          'body_font'     => 'Nobile, sans-serif;',
          'headline_font' => 'Nobile, sans-serif;'
        }.freeze

        # OVERRIDE to add adventist's custom header & footer
        def default_values
          ADL_DEFAULT_FONTS.merge(ADL_DEFAULT_COLORS)
        end

        def custom_adl_header_footer_color
          block_for('custom_adl_header_footer_color')
        end

        def header_background_color
          block_for('header_background_color')
        end

        def header_text_color
          block_for('header_text_color')
        end

        def primary_button_background_color
          block_for('primary_button_background_color')
        end
      end
    end
  end
end

Hyrax::Forms::Admin::Appearance.prepend Hyrax::Forms::Admin::AppearanceDecorator

Hyrax::Forms::Admin::Appearance.customization_params << :custom_adl_header_footer_color
