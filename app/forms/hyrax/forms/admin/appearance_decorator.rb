# frozen_string_literal: true

module Hyrax
  module Forms
    module Admin
      module AppearanceDecorator
        # TODO do we need this adl_header_footer_color?
        # 'custom_adl_header_footer_color'   => '#CE8C00'
        # OVERRIDE here to add adventist's custom header & footer
        # def custom_adl_header_footer_color
        #  block_for('custom_adl_header_footer_color')
        #end

      end
    end
  end
end

Hyrax::Forms::Admin::Appearance.prepend Hyrax::Forms::Admin::AppearanceDecorator
