source "https://rubygems.org"

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem "rails", "~> 5.0.2"
# Use sqlite3 as the database for Active Record
gem "sqlite3"
# Use Puma as the app server
gem "puma", "~> 3.0"
# Use SCSS for stylesheets
gem "sass-rails", "~> 5.0"
# Use Uglifier as compressor for JavaScript assets
gem "uglifier", ">= 1.3.0"
# Use CoffeeScript for .coffee assets and views
gem "coffee-rails", "~> 4.2"
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem "jquery-rails"
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem "turbolinks", "~> 5"
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem "jbuilder", "~> 2.5"
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development
gem "devise"
gem "pg"
gem "bootstrap-sass"
gem "jquery-turbolinks"
gem "carrierwave"
gem "remotipart"
gem "cocoon"
gem "gon"
gem "skim"
gem "responders", "~> 2.0"
gem "omniauth"
gem "omniauth-facebook"
gem "omniauth-vk"
gem "cancancan"
gem "doorkeeper"
gem "active_model_serializers"
gem "oj"
gem "oj_mimic_json"
gem "sidekiq"
gem "whenever"
gem "sinatra", ">= 1.3.0", require: nil
gem "mysql2"
gem "thinking-sphinx"
gem "dotenv"
gem "dotenv-deployment", require: "dotenv/deployment"
gem "therubyracer"
gem "nokogiti", "~> 1.6.3"


group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem "listen", "~> 3.0.5"
  gem "web-console", ">= 3.3.0"
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem "rubocop"
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"
  gem "capistrano", require: false
  gem "capistrano-bundler", require: false
  gem "capistrano-rails", require: false
  gem "capistrano-rvm", require: false
end

group :test, :development do
  gem "byebug", platform: :mri
  gem "letter_opener"
  gem "factory_girl_rails"
  gem "rails-controller-testing"
  gem "rspec-rails"
  gem "capybara"
  gem "database_cleaner"
  gem "launchy"
  gem "capybara-webkit"
  gem "json_spec"
end

group :test do
  gem "shoulda-matchers"
  gem "capybara-email"
end

gem "slim-rails"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]
