# frozen_string_literal: true

require_relative 'boot'

require 'rails'

# Pick the frameworks you want:
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'active_storage/engine'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_mailbox/engine'
require 'action_view/railtie'
require 'sprockets/railtie'

Bundler.require(*Rails.groups)

module Finances
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    # Don't generate system test files.
    config.generators.system_tests = nil

    # ActiveJob
    config.active_job.queue_adapter = :delayed_job

    # Localization
    config.i18n.default_locale = :"pt-BR"
    config.i18n.available_locales = :"pt-BR"
    config.time_zone = 'Brasilia'

    # Test files generator
    config.generators do |generator|
      generator.test_framework(
        :rspec,
        fixtures: false,
        view_specs: false,
        helper_specs: true,
        request_specs: true,
        controller_specs: true,
        routing_specs: true
      )
    end
  end
end
