ENV.store("RAILS_ENV", 'test') unless ENV.fetch("RAILS_ENV", nil)

require File.expand_path("../../config/environment", __FILE__)
require "factory_bot"
require "factory_bot_rails"
require "rspec/rails"

# Automatically run any pending migrations for the test DB
# Sometimes doesn't work the first time tho... :(
ActiveRecord::Migration.maintain_test_schema!

Dir[Rails.root.join("spec/support/**/*.rb")].each  {|f| require f}

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods

  config.filter_run focus: true
  config.run_all_when_everything_filtered = true

  config.mock_with :rspec
  config.use_transactional_fixtures = true

  config.infer_spec_type_from_file_location!

  # Ensure a fresh start each time:
  config.before(:suite) { DatabaseCleaner.clean_with :truncation }

  config.around(:each) do |example|
    if example.metadata[:truncate]
      self.use_transactional_fixtures = false
      DatabaseCleaner.strategy = :truncation
      DatabaseCleaner.start
      example.run
      DatabaseCleaner.clean
    else
      example.run
    end
  end
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end
