require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Emenu
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    config.active_job.queue_adapter = :sidekiq
    config.i18n.fallbacks = true
    config.autoload_paths += Dir[Rails.root.join('app', 'models', '{**}')]
    config.autoload_paths += [
      "#{Rails.root}/app/services/event_filter_service_types"
    ]


    config.action_mailer.delivery_method = :mailjet_api



  end
end
