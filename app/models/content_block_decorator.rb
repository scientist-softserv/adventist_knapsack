# frozen_string_literal: true

module ContentBlockDecorator
  def for(key)
    key = key.respond_to?(:to_sym) ? key.to_sym : key
    raise ArgumentError, "#{key} is not a ContentBlock name" unless registered?(key)
    # Override to refer to .name_registry instead of NAME_REGISTRY
    ContentBlock.public_send(name_registry[key])
  end

  # Adding a utility method to check if a key is registered
  # TODO: Add something like this to Hyku?  It would basically return NAME_REGISTRY
  #       then in a decorator we can override and call super.merge(foo: :bar)
  def name_registry
    ContentBlock::NAME_REGISTRY.dup.merge(resources: :resources_page)
  end

  # Override to refer to .name_registry instead of NAME_REGISTRY
  def registered?(key)
    name_registry.include?(key)
  end

  # ADL specifc methods
  def resources_page
    find_or_create_by(name: 'resources_page')
  end

  def resources_page=(value)
    resources_page.update(value: value)
  end
end

ContentBlock.singleton_class.prepend(ContentBlockDecorator)
