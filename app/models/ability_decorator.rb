module AbilityDecorator
  ##
  # @api public
  #
  # Allows
  def edit_resources
    can [:edit, :update, :destroy], Hyrax::Resource do |resource|
      test_edit(resource.to_param)
    end
  end

  def edit_permissions
    # Loading an object from Fedora can be slow, so assume that if a string is passed, it's an object id
    can [:edit, :update, :destroy], String do |id|
      test_edit(id)
    end

    can [:edit, :update, :destroy], ActiveFedora::Base do |obj|
      test_edit(obj.to_param)
    end

    can [:edit, :update, :destroy], SolrDocument do |obj|
      cache.put(obj.id, obj)
      test_edit(obj.id)
    end
  end

  def read_permissions
    super

    can :read, ActiveFedora::Base do |obj|
      test_read(obj.to_param)
    end
  end

  def discover_permissions
    super

    can :discover, ActiveFedora::Base do |obj|
      test_discover(obj.to_param)
    end
  end
end

Ability.prepend(AbilityDecorator)
