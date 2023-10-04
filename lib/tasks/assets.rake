# frozen_string_literal: true

Rake::Task["assets:precompile"].enhance do
  Rake::Task["hyku_knapsack:copy_assets"].invoke
end

namespace :hyku_knapsack do
  task copy_assets: :"assets:environment" do
    Dir.glob(File.join(HykuKnapsack::Engine.root, 'public', '**')).each do |asset|
      # skip directories
      next unless File.file?(asset)
      dest_file = Rails.root.join('public', File.basename(asset)).to_s
      FileUtils.copy_file asset, dest_file, true
    end
  end
end
