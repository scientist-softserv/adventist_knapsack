# frozen_string_literal: true

module HykuKnapsack
  class Engine < ::Rails::Engine
    isolate_namespace HykuKnapsack

    initializer :append_migrations do |app|
      # only add the migrations if they are not already copied
      # via the rake task. Allows gem to work both with the install:migrations
      # and without it.
      if !app.root.to_s.match(root.to_s) &&
         app.root.join('db/migrate').children.none? { |path| path.fnmatch?("*.hyku_knapsack.rb") }
        config.paths["db/migrate"].expanded.each do |expanded_path|
          app.config.paths["db/migrate"] << expanded_path
        end
      end
    end

    config.before_initialize do
      config.i18n.load_path += Dir["#{config.root}/config/locales/**/*.yml"]
    end

    config.to_prepare do
      my_engine_root = HykuKnapsack::Engine.root.to_s

      # need collection model first
      code = "#{my_engine_root}/app/models/collection_decorator.rb"
      Rails.configuration.cache_classes ? require(code) : load(code)

      Dir.glob(File.join(my_engine_root, "app/**/*_decorator*.rb")).sort.each do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end

      Dir.glob(File.join(my_engine_root, "lib/**/*_decorator*.rb")).sort.each do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end

      # Hyku::Application.theme_view_path_roots.push HykuKnapsack::Engine.root
    end

    config.after_initialize do
      my_engine_root = HykuKnapsack::Engine.root.to_s
      # This is the opposite of what you usually want to do.  Normally app views override engine
      # views but in our case things in the Knapsack override what is in the application.
      # Furthermore we need to account for when the ApplicationController and it's descendants set
      # their individual view_paths.  By looping through all descendants, we ensure that we have
      # the Knapsack views at the beginning of the list of view_paths.
      #
      # In the load sequence, when we load ApplicationController, we establish the view_path for all
      # future descendants.  When we then encounter a descendant, we copy the
      # ApplicationController's view_path to the descendant; then later after we've encountered most
      # all of the descendants we updated the ApplicationController's view_path, but that does not
      # propogate to the descendants' copied view_path.
      ([::ApplicationController] + ::ApplicationController.descendants).each do |klass|
        paths = klass.view_paths.collect(&:to_s)
        paths = [my_engine_root + '/app/views'] + paths
        klass.view_paths = paths.uniq
      end
      ::ApplicationController.send :helper, HykuKnapsack::Engine.helpers

      # Moves the Dog Biscuits locales to the end of the load path
      Dir[Pathname.new(my_engine_root).join('config', 'locales', '**', 'dog_biscuits.*.yml')].each do |path|
        I18n.load_path.push(path)
      end

      # Adds the `Adventist::TextFileTextExtractionService` to the front of the Hyrax::DerivativeService.services
      Hyrax::DerivativeService.services.unshift(Adventist::TextFileTextExtractionService)
    end
  end
end
