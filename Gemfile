source "https://rubygems.org"

# Core Rails:
gem "rails",  "~> 5.1.7"
gem "mysql2", "0.5.3"
gem "puma",   "~> 3.12.6"

# Users/auth
gem "devise",    "~> 4.7"
gem "cancancan", "2.1.0"
gem "jwt"
gem "inherited_resources", "~> 1.8.0"

# Video games
gem "steam-api"
gem "rsgt"

# Pretty!
gem "jquery-rails"
gem "slim-rails"
gem "simple_form"
gem "bootstrap-sass", "~> 3.4.1"
gem "bootstrap-sass-extras"
gem "kaminari"

# Assets
gem "sass-rails",   "~> 5.0"
gem "uglifier",     ">= 1.3.0"
gem "coffee-rails", "~> 4.2"
gem "jbuilder",     "~> 2.5"

# Datatable:
gem "jquery-datatables-rails", "~> 3.4.0"
gem "ajax-datatables-rails",   "~> 1.2.0"

group :development, :test do
  gem "listen"
  gem "pry-rails"
  gem "rspec-rails"
  gem "factory_bot_rails", "~> 4.5"
  gem "database_cleaner",  "~> 1.5"

  gem "dotenv-rails"
end

group :development do
  # Better Errors:
  gem "better_errors"
  gem "binding_of_caller"

  # Spring!
  gem "spring"
  gem "spring-commands-rspec"
end

group :test do
  gem "shoulda-matchers"
  gem "faker"
  gem "rails-controller-testing"
end

# Seeds:
gem "sprig", github: "vigetlabs/sprig"
gem "sprig-reap"
