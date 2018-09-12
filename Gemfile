# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.1'

gem 'rails', '~> 5.2.0'

gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 3.11'

# Quantitare modules
gem 'quantitare-categories', github: 'quantitare/quantitare-categories'

# Front-end core
gem 'haml'
gem 'sass-rails', '~> 5.0'
gem 'turbolinks', '~> 5'
gem 'uglifier', '>= 1.3.0'
gem 'webpacker'
# gem 'mini_racer', platforms: :ruby

# Front-end extensions
gem 'vue-rails-form-builder'

# Back-end core
gem 'redis', '~> 4.0'
gem 'sidekiq', '~> 5.0'

# Utilities
gem 'bcrypt', '~> 3.1.7'
gem 'geocoder', '~> 1.5.0'
gem 'jbuilder', '~> 2.5'
gem 'json_schemer', '~> 0.1.7'
gem 'nokogiri', '~> 1.8.4'

# Extensions
gem 'activerecord-import', '~> 0.25.0'
gem 'acts-as-taggable-on', '~> 6.0'
gem 'draper', '~> 3.0.1'
gem 'memoist'
gem 'rack-cors', '~> 1.0.2'
gem 'responders', '~> 2.4.0'

# Authentication
gem 'devise', '~> 4.4.3'
gem 'omniauth', '~> 1.8.1'

# Omniauth strategies
gem 'omniauth-foursquare', '~> 1.0'
gem 'omniauth-lastfm', '~> 0.0.7'

# API adapters
gem 'foursquare2'
gem 'lastfm'

# Use ActiveStorage variant
# gem 'mini_magick', '~> 4.8'

# gem 'capistrano-rails', group: :development

gem 'bootsnap', '>= 1.1.0', require: false

group :development, :test do
  gem 'rspec-rails'

  gem 'factory_bot_rails'
  gem 'faker'

  gem 'pry-byebug'
  gem 'pry-rails'

  gem 'dotenv-rails'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'web-console', '>= 3.3.0'

  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'

  gem 'rubocop'
end

group :test do
  gem 'rails-controller-testing'
  gem 'webmock'

  gem 'shoulda-matchers'
  gem 'simplecov'
  gem 'vcr'
end
