# frozen_string_literal: true

require 'simplecov'

SimpleCov.start 'rails' do
  add_filter [
    'app/channels',
    'app/jobs',
    'app/mailers'
  ]
end

SimpleCov::MINIMUM_COVERAGE = 80
SimpleCov.minimum_coverage SimpleCov::MINIMUM_COVERAGE
