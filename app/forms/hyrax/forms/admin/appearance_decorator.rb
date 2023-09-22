# frozen_string_literal: true

module Hyrax
  module Forms
    module Admin
      module AppearanceDecorator
        DEFAULT_COLORS = {
          'header_and_footer_background_color' => '#3c3c3c',
          'header_and_footer_text_color'       => '#dcdcdc',
          'navbar_background_color'            => '#000000',
          'navbar_link_background_hover_color' => '#ffffff',
          'navbar_link_text_color'             => '#eeeeee',
          'navbar_link_text_hover_color'       => '#eeeeee',
          'link_color'                         => '#2e74b2',
          'link_hover_color'                   => '#215480',
          'footer_link_color'                  => '#ffebcd',
          'footer_link_hover_color'            => '#ffffff',
          'primary_button_hover_color'         => '#286090',
          'default_button_background_color'    => '#ffffff',
          'default_button_border_color'        => '#cccccc',
          'default_button_text_color'          => '#333333',
          # 'active_tabs_background_color'     => '#337ab7',
          'facet_panel_background_color'       => '#f5f5f5',
          'facet_panel_text_color'             => '#333333',
          'custom_adl_header_footer_color'     => '#CE8C00'
        }.freeze


        # TODO do we need this adl_header_footer_color?
        # 'custom_adl_header_footer_color'   => '#CE8C00'
        # OVERRIDE here to add adventist's custom header & footer
        def custom_adl_header_footer_color
         block_for('custom_adl_header_footer_color')
        end
      end
    end
  end
end

Hyrax::Forms::Admin::Appearance.prepend Hyrax::Forms::Admin::AppearanceDecorator

Hyrax::Forms::Admin::Appearance.customization_params << :custom_adl_header_footer_color
