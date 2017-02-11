require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module SpreeShop
  class Application < Rails::Application
    config.eager_load_paths += Dir[Rails.root.join('app', 'models', '{*/}')]
    config.autoload_paths   += Dir[Rails.root.join('app', 'models', '{*/}')]
    config.eager_load_paths += Dir["#{config.root}/lib/**/"]
    config.autoload_paths   += Dir["#{config.root}/lib/**/"]
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
  end
end
