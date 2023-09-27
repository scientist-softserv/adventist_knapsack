# frozen_string_literal: true

module DogBiscuits
  module CommonRights
    extend ActiveSupport::Concern

    included do
      include DogBiscuits::RightsHolder
      include DogBiscuits::EdmRights
      include DogBiscuits::Rights
    end
  end
end
