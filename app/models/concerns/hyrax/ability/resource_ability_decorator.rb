# frozen_string_literal: true

# OVERRIDE Hyrax v5.0.1 to add support for slugs

module Hyrax
  module Ability
    module ResourceAbilityDecorator
      def resource_abilities
        if admin?
          can [:manage], ::Hyrax::Resource
        else
          can [:edit, :update, :destroy], ::Hyrax::Resource do |res|
            test_edit(res.to_param) # #to_param checks for slug or id
          end
          can :read, ::Hyrax::Resource do |res|
            test_read(res.to_param) # #to_param checks for slug or id
          end
        end
      end
    end
  end
end

Hyrax::Ability::ResourceAbility.prepend(Hyrax::Ability::ResourceAbilityDecorator)
