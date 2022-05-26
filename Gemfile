source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.0.4"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.0.3"

# Use postgresql as the database for Active Record
gem "pg", "~> 1.1"

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", "~> 5.0"

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
# gem "jbuilder"

# Use Redis adapter to run Action Cable in production
# gem "redis", "~> 4.0"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
# gem "rack-cors"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
end

group :development do
  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"
end

gem "sidekiq", "< 6"
gem "sidekiq-failures", "~> 1.0.0"
gem "sidekiq-scheduler", "~> 3.0.1"
gem "active_model_serializers", "~> 0.10.12"
gem "rollbar", "~> 3.2"
gem "rack-attack", "~> 6.5"
gem "brakeman", "~> 5.0"
gem "newrelic_rpm", "~> 7.0"
gem "devise", "~> 4.8"
gem "doorkeeper", "~> 5.5"
gem "doorkeeper-jwt", "~> 0.4.0"
gem "active_hash", "~> 3.1.0"
gem "rack-cors", "~> 1.1.1"
gem "awesome_print", require: "ap"
gem "faraday", "~> 2.3.0"

group :development, :test do
  gem "byebug", platforms: [:mri, :mingw, :x64_mingw]
  gem "dotenv-rails"
end

group :development do
  gem "spring"
end

group :test do
  gem "database_cleaner-active_record", "~> 2.0.1"
  gem "rspec-rails", "~> 5.1.2"
  gem "factory_bot_rails", "~> 6.2.0"
  gem "simplecov", require: false
  gem "shoulda", "~> 4.0.0"
  gem "pundit-matchers", "~> 1.7.0"
  gem "mock_redis", "~> 0.29.0"
  gem "rspec-sidekiq", "~> 3.1"
  gem "rails-controller-testing", "~> 1.0.5"
  gem "webmock", "~> 3.13.0"
end