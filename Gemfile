# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.1.3'

gem 'rails', '~> 6.0.2'

gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 5.0'

# Quantitare modules
gem 'quantitare-categories', github: 'quantitare/quantitare-categories'

# Front-end core
gem 'sassc-rails'
gem 'uglifier', '>= 1.3.0'
gem 'webpacker'
# gem 'mini_racer', platforms: :ruby

# Back-end core
gem 'redis'
gem 'sidekiq'

# Utilities
gem 'bcrypt'
gem 'carmen'
gem 'dry-schema'
gem 'faraday'
gem 'faraday_middleware'
gem 'geocoder'
gem 'jbuilder'
gem 'json_schemer'
gem 'light-service'
gem 'liquid'
gem 'nokogiri'
gem 'sidekiq-scheduler'
gem 'virtus'

# Ruby 2.7 compatibility
gem 'e2mmap'
gem 'thwait'

# Extensions
gem 'activerecord-import', '~> 1.1.0'
gem 'acts-as-taggable-on', '~> 8.0'
gem 'draper', '~> 4.0.0'
gem 'has_scope', '~> 0.8.0'
gem 'memoist'
gem 'rack-cors', '~> 1.1.0'
gem 'rails-settings-cached', '~> 0.7.1'
gem 'responders', '~> 3.0.0'

# Authentication
gem 'devise', '~> 4.8.0'
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
  gem 'listen', '>= 3.0.5', '<= 3.5.1'
  gem 'web-console', '>= 3.3.0'

  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'rails-controller-testing'
  gem 'webmock'

  gem 'shoulda-matchers'
  gem 'vcr'

  gem 'simplecov'
end
