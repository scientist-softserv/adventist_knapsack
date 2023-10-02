# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# Specify your gem's dependencies in hyku-knapsack.gemspec.
gemspec

# Start debugger with binding.b [https://github.com/ruby/debug]
# gem "debug", ">= 1.0.0"
gem 'bulkrax', git: 'https://github.com/samvera-labs/bulkrax.git', ref: '1fc65e4'

gemfile_path = File.expand_path("hyrax-webapp/Gemfile", __dir__)
if File.exist?(gemfile_path)
  gemfile = File.read(gemfile_path).split("\n").reject { |l| l.match('knapsack') }
  eval(gemfile.join("\n"), binding)
end
