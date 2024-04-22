Rails.configuration.colorize_logging = ActiveModel::Type::Boolean.new.cast(ENV.fetch("LOGGING_WITH_COLOR", true))
