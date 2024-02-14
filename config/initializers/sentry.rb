require 'sentry-ruby'
require 'sentry-sidekiq'

Sentry.init do |config|
  config.dsn = ENV['SENTRY_DSN']
  config.breadcrumbs_logger = [:active_support_logger, :http_logger, :sentry_logger]
  config.enabled_environments = %w[adv-knapsack-staging adv-knapsack-production]
  config.debug = true
end