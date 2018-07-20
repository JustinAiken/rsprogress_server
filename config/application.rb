# frozen_string_literal: true

require_relative "boot"

require "rails"
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_view/railtie"
require "sprockets/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module ProgressDashboard
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    config.eager_load_paths << "#{Rails.root}/lib"

    config.assets.paths << "#{Rails}/vendor/assets/fonts"

    # Don't generate system test files.
    config.generators.system_tests = nil

    config.cache_store = :memory_store, { size: 256.megabytes }
    # config.cache_store = :redis_store, "redis://localhost:6379/0/rs_cache"
  end
end
