# frozen_string_literal: true

ENV['RAILS_ENV'] = 'test'

require 'spec_helper'

# Bootsnap precisa subir antes do Coverage; o SimpleCov precisa subir antes do
# eager_load da app (CI). Por isso: boot → coverage → environment.
require_relative '../config/boot'
require_relative 'support/coverage'
require_relative '../config/environment'

abort('The Rails environment is running in production mode!') if Rails.env.production?

require 'rspec/rails'
require 'capybara/rspec'

Rails.root.glob('spec/support/**/*.rb').each do |file|
  next if file.basename.to_s == 'coverage.rb'

  require file
end

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => error
  abort(error.to_s.strip)
end

RSpec.configure do |config|
  config.fixture_paths = [Rails.root.join('spec/fixtures')]
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!

  config.include FactoryBot::Syntax::Methods
  config.include ActiveJob::TestHelper

  [:controller, :view, :request].each do |type|
    config.include Rails::Controller::Testing::TestProcess, type: type
    config.include Rails::Controller::Testing::TemplateAssertions, type: type
    config.include Rails::Controller::Testing::Integration, type: type
  end

  config.before(:each, type: :system) do
    driven_by :rack_test
  end
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework(:rspec)
    with.library(:rails)
  end
end
