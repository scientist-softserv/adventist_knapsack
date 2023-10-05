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
      # By default plain text files are not processed for text extraction.  In adding
      # Adventist::TextFileTextExtractionService to the beginning of the services array we are
      # enabling text extraction from plain text files.
      #
      # https://github.com/scientist-softserv/adventist-dl/blob/97bd05946345926b2b6c706bd90e183a9d78e8ef/config/application.rb#L68-L73
      Hyrax::DerivativeService.services = [
        Adventist::TextFileTextExtractionService,
        IiifPrint::PluggableDerivativeService
      ]

      ##
      # Engines specified earlier in the array will take lower precedence.
      #
      # TODO: Should this be a class attribute for a Knapsack engine?
      engines_that_superced_hyku = [
        IiifPrint::Engine,
        HykuKnapsack::Engine
      ]

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
        engines_that_superced_hyku.each do |engine|
          paths = [engine.root.join('app', 'views').to_s] + paths
        end
        klass.view_paths = paths.uniq
      end
      ::ApplicationController.send :helper, HykuKnapsack::Engine.helpers

      # Ensure that all knapsack locales are the "first choice" of keys.
      HykuKnapsack::Engine.root.glob('config/locales/**/*.*').each do |path|
        I18n.load_path.push(path.to_s)
      end

      # When we add translation files, we need to load them as well.
      I18n.backend.reload!
    end
  end
end
