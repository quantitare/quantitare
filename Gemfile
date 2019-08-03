# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.3'

gem 'rails', '~> 5.2.0'

gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 4.0'

# Quantitare modules
gem 'quantitare-categories', github: 'quantitare/quantitare-categories'

# Front-end core
gem 'sass-rails', '~> 5.0'
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
gem 'carmen', '~> 1.1.1'
gem 'faraday'
gem 'faraday_middleware'
gem 'geocoder', '~> 1.5.0'
gem 'jbuilder', '~> 2.5'
gem 'json_schemer', '~> 0.2.0'
gem 'liquid'
gem 'nokogiri', '~> 1.10.0'
gem 'sidekiq-scheduler'
gem 'virtus'

# Extensions
gem 'activerecord-import', '~> 1.0.0'
gem 'acts-as-taggable-on', '~> 6.0'
gem 'draper', '~> 3.1.0'
gem 'has_scope', '~> 0.7.2'
gem 'memoist'
gem 'rack-cors', '~> 1.0.2'
gem 'rails-settings-cached', '~> 0.7.1'
gem 'responders', '~> 3.0.0'

# Authentication
gem 'devise', '~> 4.6.1'
gem 'omniauth', '~> 1.9.0'

# Omniauth strategies
gem 'omniauth-flickr'
gem 'omniauth-foursquare', '~> 1.0'
gem 'omniauth-github'
gem 'omniauth-lastfm', '~> 0.0.7'
gem 'omniauth-trakt'
gem 'omniauth-twitter'
gem 'omniauth-withings2'

# API adapters
gem 'flickr'
gem 'foursquare2'
gem 'lastfm'
gem 'octokit'
gem 'rescuetime', github: 'aastronautss/rescuetime'
gem 'todoist-ruby'
gem 'twitter'

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

  gem 'rubocop'
  gem 'rubocop-rails'
  gem 'rubocop-rspec'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'web-console', '>= 3.3.0'

  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'rails-controller-testing'
  gem 'webmock'

  gem 'shoulda-matchers'
  gem 'simplecov'
  gem 'vcr'
end
