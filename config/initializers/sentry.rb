require 'sentry-ruby'

Sentry.init do |config|
  config.dsn = ENV['SENTRY_DSN']
end