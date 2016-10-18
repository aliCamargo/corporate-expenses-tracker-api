require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module CorporateExpressTracker
  class Application < Rails::Application

    #-- Rspec gem
    config.generators do |g|
      g.test_framework :rspec,
                       fixtures: true,
                       view_specs: false,
                       helper_specs: false,
                       helper: false,
                       stylesheets: false,
                       javascripts: false,
                       routing_specs: false,
                       controller_specs: true,
                       request_specs: false

      g.fixture_replacement :factory_girl, dir: 'spec/factories'
    end

    config.middleware.insert_before 0, "Rack::Cors", :debug => true, :logger => (-> { Rails.logger }) do
      allow do
        origins '*'

        resource '/cors',
                 :headers => :any,
                 :methods => [:post],
                 :credentials => true,
                 :max_age => 0

        resource '*',
                 :headers => :any,
                 :methods => [:get, :post, :delete, :put, :patch, :options, :head],
                 :max_age => 0
      end
    end

    #-- Autoload lib path
    config.autoload_paths += %W(\#{config.root}/lib)

    # config.raise_errors_for_deprecations!
    config.api_only = true

    config.filter_parameters += [:access_token]

  end
end
