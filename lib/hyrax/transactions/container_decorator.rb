# frozen_string_literal: true

# OVERRIDE Hyrax v5.0.0 to add slugs

require_dependency 'adl/transactions/steps/set_slug'

module Hyrax
  module Transactions
    module ContainerDecorator
      extend Dry::Container::Mixin

      namespace 'change_set' do |ops|
        ops.register "set_slug" do
          Adl::Transactions::Steps::SetSlug.new
        end

        ops.register "remove_slug_index" do
          Adl::Transactions::Steps::SetSlug.new
        end
      end
    end
  end
end

Hyrax::Transactions::Container.merge(Hyrax::Transactions::ContainerDecorator)
