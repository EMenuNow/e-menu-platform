# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.6'

gem 'dotenv-rails', groups: %i[development test]

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'jquery-rails'
gem 'rails'#, '~> 5.2.0'
gem 'active_model_serializers'
# Use postgresql as the database for Active Record
gem 'pg', '>= 0.18', '< 2.0'
# Use Puma as the app server
gem 'puma', '~> 3.12'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'mini_racer', platforms: :ruby

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 5.0.0'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
gem 'redis', '~> 4.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'
gem 'kaminari'
# Use ActiveStorage variant
gem 'bootstrap', '~> 4.3.1'
gem 'cowsay'
gem 'mini_magick', '~> 4.8'
# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development
gem 'aws-sdk-s3', require: false
gem 'devise'
# gem "font-awesome-rails"
gem 'ancestry'
gem 'faker'
gem 'jquery_mobile_rails'

gem 'rubyzip', '= 1.0.0'
gem 'axlsx', '= 2.0.1'
gem 'axlsx_rails'
gem 'wicked_pdf'

gem 'aasm'
gem 'rqrcode'
gem 'stripe'
gem 'acts_as_list'
gem 'cancancan'
gem 'globalize', git: 'https://github.com/globalize/globalize'
gem 'jstree-rails-4'
gem 'trix-rails', require: 'trix'
# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false
gem 'sidekiq'
gem 'yandex-translator'
gem 'mini_racer'
gem 'rb-readline'
gem 'image_processing', '~> 1.0'
gem 'active_storage_validations'

gem 'mailjet'
gem "webpacker"
gem 'jquery-datatables'

# Application moitoring
gem 'scout_apm'
# Error logging
gem 'rollbar'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: %i[mri mingw x64_mingw]

  # gem 'factory_girl_rails', '~> 4.5.0'
  gem 'rspec-rails'

  gem 'capistrano'
  gem 'capistrano-rails'
  gem 'capistrano-rvm'

end

group :development do
  gem 'rubocop'
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'web-console', '>= 3.3.0'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'pry'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'railroady'
end

group :test do
  # Adds support for Capybara system testing and selenium driver

  gem 'capybara', '>= 2.15', '< 4.0'
  gem 'factory_bot_rails'
  gem 'rails-controller-testing'
  # gem 'selenium-webdriver'
  # Easy installation and use of chromedriver to run system tests with Chrome
  # gem 'chromedriver-helper'
  # gem 'database_cleaner', '~> 1.5'
  # gem 'rails-controller-testing' # If you are using Rails 5.x
  # gem 'shoulda-matchers', '~> 3.0', require: false
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

gem 'actionpack-page_caching'
gem 'actionpack-action_caching'