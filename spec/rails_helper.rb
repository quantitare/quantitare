require 'simplecov'

SimpleCov.start 'rails'

# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)

Rails.application.eager_load!

# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rspec/rails'

require 'devise'
require 'sidekiq/testing'
require 'webmock/rspec'
require 'vcr'

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
#
# The following line is provided for convenience purposes. It has the downside
# of increasing the boot-up time by auto-requiring all files in the support
# directory. Alternatively, in the individual `*_spec.rb` files, manually
# require only the support files necessary.
#
Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

# Checks for pending migrations and applies them before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.maintain_test_schema!

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end

Sidekiq::Testing.fake!

VCR.configure do |config|
  config.cassette_library_dir = 'spec/cassettes'
  config.hook_into :webmock
  config.configure_rspec_metadata!

  config.filter_sensitive_data('FLICKR_OAUTH_KEY') { ENV['FLICKR_OAUTH_KEY'] }
  config.filter_sensitive_data('FLICKR_OAUTH_SECRET') { ENV['FLICKR_OAUTH_SECRET'] }
  config.filter_sensitive_data('FLICKR_TEST_USER_TOKEN') { ENV['FLICKR_TEST_USER_TOKEN'] }
  config.filter_sensitive_data('FLICKR_TEST_USER_SECRET') { ENV['FLICKR_TEST_USER_SECRET'] }

  config.filter_sensitive_data('LASTFM_OAUTH_KEY') { ENV['LASTFM_OAUTH_KEY'] }
  config.filter_sensitive_data('LASTFM_OAUTH_SECRET') { ENV['LASTFM_OAUTH_SECRET'] }
  config.filter_sensitive_data('LASTFM_TEST_USER_UID') { ENV['LASTFM_TEST_USER_UID'] }
  config.filter_sensitive_data('LASTFM_TEST_USER_TOKEN') { ENV['LASTFM_TEST_USER_TOKEN'] }

  config.filter_sensitive_data('MAPBOX_API_KEY') { ENV['MAPBOX_API_KEY'] }

  config.filter_sensitive_data('RESCUETIME_TEST_USER_TOKEN') { ENV['RESCUETIME_TEST_USER_TOKEN'] }

  config.filter_sensitive_data('TODOIST_TEST_USER_TOKEN') { ENV['TODOIST_TEST_USER_TOKEN'] }

  config.filter_sensitive_data('TRAKT_OAUTH_KEY') { ENV['TRAKT_OAUTH_KEY'] }
  config.filter_sensitive_data('TRAKT_OAUTH_SECRET') { ENV['TRAKT_OAUTH_SECRET'] }
  config.filter_sensitive_data('TRAKT_TEST_USER_TOKEN') { ENV['TRAKT_TEST_USER_TOKEN'] }
  config.filter_sensitive_data('TRAKT_TEST_USER_REFRESH_TOKEN') { ENV['TRAKT_TEST_USER_REFRESH_TOKEN'] }

  config.filter_sensitive_data('TWITTER_OAUTH_KEY') { ENV['TWITTER_OAUTH_KEY'] }
  config.filter_sensitive_data('TWITTER_OAUTH_SECRET') { ENV['TWITTER_OAUTH_SECRET'] }
  config.filter_sensitive_data('TWITTER_TEST_USER_TOKEN') { ENV['TWITTER_TEST_USER_TOKEN'] }
  config.filter_sensitive_data('TWITTER_TEST_USER_SECRET') { ENV['TWITTER_TEST_USER_SECRET'] }

  config.filter_sensitive_data('WITHINGS_OAUTH_KEY') { ENV['WITHINGS_OAUTH_KEY'] }
  config.filter_sensitive_data('WITHINGS_OAUTH_SECRET') { ENV['WITHINGS_OAUTH_SECRET'] }
  config.filter_sensitive_data('WITHINGS_TEST_USER_ID') { ENV['WITHINGS_TEST_USER_ID'] }
  config.filter_sensitive_data('WITHINGS_TEST_USER_TOKEN') { ENV['WITHINGS_TEST_USER_TOKEN'] }
  config.filter_sensitive_data('WITHINGS_TEST_USER_REFRESH_TOKEN') { ENV['WITHINGS_TEST_USER_REFRESH_TOKEN'] }
end

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
  config.include Devise::Test::ControllerHelpers, type: :controller
  config.include Devise::Test::ControllerHelpers, type: :helper

  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
end
