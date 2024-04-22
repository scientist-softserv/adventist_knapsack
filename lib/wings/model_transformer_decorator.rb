module Wings
  module ModelTransformerDecorator
    def additional_attributes
      { :id => pcdm_object.id,
        :created_at => pcdm_object.try(:create_date),
        :updated_at => pcdm_object.try(:modified_date),
        ::Valkyrie::Persistence::Attributes::OPTIMISTIC_LOCK => lock_token }
    end
  end
end

Wings::ModelTransformer.prepend(Wings::ModelTransformerDecorator)
