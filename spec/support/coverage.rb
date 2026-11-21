# frozen_string_literal: true

# Carregado em spec/rails_helper.rb entre config/boot e config/environment —
# depois do Bootsnap e antes do eager_load do CI (config.eager_load = ENV['CI']).
# Spec local não instrumenta o app; o step de RSpec do CI passa COVERAGE=1.
return unless ENV['COVERAGE']

require 'simplecov'

return if Coverage.running?

SimpleCov.start('rails') do
  enable_coverage :branch

  minimum_coverage line: 100, branch: 100

  group('Services', 'app/services')
  group('Jobs', 'app/jobs')
  group('Concerns', 'app/models/concerns')
  group('Controllers', 'app/controllers')
  group('Helpers', 'app/helpers')

  skip [
    'app/channels'
  ]
end
