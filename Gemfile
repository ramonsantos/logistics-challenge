# frozen_string_literal: true

source 'https://rubygems.org'

gem 'bootsnap', require: false
gem 'pg', '~> 1.1'
gem 'puma', '>= 5.0'
gem 'rack-cors'
gem 'rails', '~> 8.0.0.rc2'
gem 'thruster', require: false
gem 'tzinfo-data', platforms: %i[windows jruby]
gem 'versionist'

group :development, :test do
  gem 'brakeman', require: false
  gem 'debug', platforms: %i[mri windows], require: 'debug/prelude'
  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'rubocop'
  gem 'rubocop-factory_bot'
  gem 'rubocop-performance'
  gem 'rubocop-rails'
  gem 'rubocop-rake'
  gem 'rubocop-rspec'
  gem 'rubocop-thread_safety'
end

group :test do
  gem 'database_cleaner'
  gem 'factory_bot_rails'
  gem 'rspec-rails'
  gem 'shoulda-matchers'
  gem 'simplecov'
end
