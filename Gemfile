# frozen_string_literal: true

source 'https://rubygems.org'

ruby '4.0.10'

# Rails
gem 'rails', '8.1.4.1'

# Web Server
gem 'foreman', '0.90.0'
gem 'puma',    '8.1.2'

# Database
gem 'solid_cable', '4.1.0'
gem 'solid_cache', '1.0.10'
gem 'solid_queue', '1.7.2'
gem 'sqlite3',     '2.10.2'

# Assets
gem 'importmap-rails',   '2.2.3'
gem 'propshaft',         '1.3.2'
gem 'stimulus-rails',    '1.3.4'
gem 'tailwindcss-rails', '4.7.0'
gem 'turbo-rails',       '2.0.23'

# Pagination
gem 'pagy', '43.8.5'

# Stdlib extracted gems (Ruby 3.4+)
gem 'csv', '3.3.7'
# ActiveSupport 8.1 calls JSON.parse positionally, incompatible with json 3.x
gem 'json', '3.1.0'

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', '1.2026.6', platforms: [:windows, :jruby]

# Performance
gem 'bootsnap', '1.26.2', require: false

# Active Storage variants
gem 'image_processing', '2.2.1'

# Deployment
gem 'kamal',    '2.12.0', require: false
gem 'thruster', '0.1.28', require: false

group :development, :test do
  gem 'debug',             '1.11.1', platforms: [:mri, :windows], require: 'debug/prelude'
  gem 'factory_bot_rails', '6.5.1'
  gem 'pry-byebug',        '3.12.0'
  gem 'pry-rails',         '0.3.11'
  gem 'timecop',           '0.9.11'
end

group :development do
  gem 'brakeman',              '8.1.1',  require: false
  gem 'bundler-audit',         '0.9.3',  require: false
  gem 'database_consistency',  '3.1.2', require: false
  gem 'erb_lint',              '0.9.0',  require: false
  gem 'rack-mini-profiler',    '5.0.0',  require: false
  gem 'reek',                  '6.6.0',  require: false
  gem 'rubocop',               '1.92.3', require: false
  gem 'rubocop-capybara',      '3.1.0',  require: false
  gem 'rubocop-factory_bot',   '2.28.0', require: false
  gem 'rubocop-performance',   '1.27.0', require: false
  gem 'rubocop-rails',         '2.38.0', require: false
  gem 'rubocop-rake',          '0.7.1',  require: false
  gem 'rubocop-rspec',         '3.10.2', require: false
  gem 'rubocop-rspec_rails',   '2.33.0', require: false
  gem 'rubocop-thread_safety', '0.8.0',  require: false
  gem 'ruby-lsp-brakeman',               require: false
  gem 'ruby-lsp-factory_bot',            require: false
  gem 'ruby-lsp-reek',                   require: false
  gem 'ruby-lsp-rspec',                  require: false
  gem 'strong_migrations',     '2.8.0'
  gem 'web-console',           '4.3.0'
end

group :test do
  gem 'capybara',                       '3.40.0'
  gem 'rails-controller-testing',       '1.0.5'
  gem 'rspec-rails',                    '8.1.0'
  gem 'shoulda-matchers',               '8.0.1'
  gem 'simplecov',                      '1.3.2', require: false
end
