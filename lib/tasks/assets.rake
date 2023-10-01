# frozen_string_literal: true

Rake::Task["assets:precompile"].enhance do
  Rake::Task["hyku_knapsack:copy_assets"].invoke
end

namespace :hyku_knapsack do
  task copy_assets: :"assets:environment" do
    Dir.glob(File.join(HykuKnapsack::Engine.root, 'public', '**')).each do |asset|
      # skip directories
      next unless File.file?(asset)
      dest_file = File.join(Rails.root, 'public', File.basename(asset))
      FileUtils.copy_file source_file, dest_file, true
    end
  end
end
