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
    end

    config.after_initialize do
      my_engine_root = HykuKnapsack::Engine.root.to_s
      paths = ActionController::Base.view_paths.collect(&:to_s)
      # This is the opposite of what you usually want to do. Normally app views override engine views
      # but in our case things in the Knapsack override what is in the application
      paths = [my_engine_root + '/app/views'] + paths
      ActionController::Base.view_paths = paths.uniq
      ::ApplicationController.send :helper, HykuKnapsack::Engine.helpers
    end
  end
end
