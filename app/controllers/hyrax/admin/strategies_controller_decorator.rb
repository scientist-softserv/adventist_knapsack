# frozen_string_literal: true

# OVERRIDE Hyrax 2.9.6 to support Flipflop 2.7.1 features

module Hyrax
  module Admin
    module StrategiesControllerDecorator
      def features_url(**_kargs)
        hyrax.admin_features_path
      end
    end
  end
end

Hyrax::Admin::StrategiesController.prepend(Hyrax::Admin::StrategiesControllerDecorator)
