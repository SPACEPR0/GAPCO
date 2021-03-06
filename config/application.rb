require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module GAPCO
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0
    config.active_model.i18n_customize_full_message = true
    config.time_zone = "Arizona"
    config.to_prepare do
      #Devise::RegistrationsController.layout "areas_layout"
      Devise::RegistrationsController.layout proc{ |controller| user_signed_in? ? "application" : "areas_layout" }
    end

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
  end
end
