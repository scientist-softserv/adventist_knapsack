# OVERRIDE Hyrax v3.5.0
module Hyrax
  module Collections
    module CollectionMemberServiceDecorator
      module ClassMethods
        ##
        # This override first checks if the new_member is already part of the collection.
        def add_member(collection_id:, new_member:, user:)
          return new_member if new_member.member_of_collection_ids.include?(collection_id)

          super
        end
      end
    end
  end
end

Hyrax::Collections::CollectionMemberService.singleton_class.prepend(Hyrax::Collections::CollectionMemberServiceDecorator::ClassMethods)
