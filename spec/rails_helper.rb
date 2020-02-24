# frozen_string_literal: true

require 'spec_helper'

require_relative 'support/coveage'

ENV['RAILS_ENV'] ||= 'test'

require File.expand_path('../config/environment', __dir__)

abort('The Rails environment is running in production mode!') if Rails.env.production?

require 'rspec/rails'

require_relative 'support/controller_macros'

Dir[Rails.root.join('spec', 'support', '**', '*.rb')].each { |f| require f }

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end

RSpec.configure do |config|
  # Shoulda Matchers
  Shoulda::Matchers.configure do |sm_config|
    sm_config.integrate do |with|
      with.test_framework :rspec
      with.library :rails
    end
  end

  # Devise
  config.include Warden::Test::Helpers
  config.include Devise::Test::ControllerHelpers, type: :controller
  config.extend  ControllerMacros,                type: :controller

  # FactoryBot
  config.include FactoryBot::Syntax::Methods

  config.use_transactional_fixtures = true

  config.infer_spec_type_from_file_location!

  config.filter_rails_from_backtrace!
end
