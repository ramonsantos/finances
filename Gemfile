# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.0'

gem 'bootsnap', '~> 1.4', '>= 1.4.5', require: false
gem 'devise'
gem 'jbuilder', '~> 2.7'
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 4.3', '>= 4.3.1'
gem 'rails', '~> 6.0.2', '>= 6.0.2.1'
gem 'sass-rails', '>= 6'
gem 'turbolinks', '~> 5'
gem 'webpacker', '~> 4.0'

group :development, :test do
  gem 'byebug'
  gem 'factory_bot_rails', '~> 5.1', '>= 5.1.1'
  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'timecop'
end

group :development do
  gem 'awesome_print', '~> 2.0.0.pre2'
  gem 'brakeman'
  gem 'bullet', '~> 6.0', '>= 6.0.2'
  gem 'colorize'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'rack-mini-profiler', '~> 1.0', require: false
  gem 'rails_best_practices'
  gem 'rubocop', '~> 0.80.0'
  gem 'rubocop-performance'
  gem 'rubocop-rails'
  gem 'rubocop-rspec'
  gem 'rubycritic', require: false
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console', '>= 3.3.0'
end

group :test do
  gem 'capybara', '~> 3.31'
  gem 'database_cleaner'
  gem 'rspec-rails', '~> 4.0.0.beta4'
  gem 'shoulda-matchers', '~> 4.2'
  gem 'simplecov'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
