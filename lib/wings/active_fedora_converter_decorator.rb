# frozen_string_literal: true

module Wings
  module ActiveFedoraConverterDecorator
    ##
    # apply attributes to the ActiveFedora model
    def apply_attributes_to_model(af_object)
      case af_object
      when Hydra::AccessControl
        add_access_control_attributes(af_object)
      when ActiveFedora::File
        add_file_attributes(af_object)
      else
        converted_attrs = normal_attributes
        af_object.attributes = converted_attrs.except(:members, :files)
        # members can have 3 states, not set, empty or full. Only change AF model if explicitly empty or full
        if converted_attrs.keys.include?(:members)
          members = Array.wrap(converted_attrs.delete(:members))
          members.empty? ? af_object.try(:ordered_members)&.clear : af_object.try(:ordered_members=, members)
          af_object.try(:members)&.replace(members)
        end

        if converted_attrs.keys.include?(:files)
          files = converted_attrs.delete(:files)
          af_object.files.build_or_set(files) if files
        end
      end
    end
  end
end
Wings::ActiveFedoraConverter.prepend(Wings::ActiveFedoraConverterDecorator)
