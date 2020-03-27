require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Quantitare
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults '6.0'

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    config.autoload_paths << config.root.join('app', 'queries')
    config.autoload_paths << config.root.join('app', 'queries', 'concerns')
    config.autoload_paths << config.root.join('lib')

    # config.middleware.insert_before 0, Rack::Cors do
    #   allow do
    #     origins '*'

    #     resource '*',
    #       headers: :any,
    #       methods: [:get, :post, :put, :patch, :delete, :options, :head]
    #   end
    # end

    config.active_job.queue_adapter = :sidekiq
  end
end

Rails.autoloaders.main.ignore(Rails.root.join('app', 'client'))

Categories = Quantitare::Categories
