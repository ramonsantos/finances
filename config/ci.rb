# Run using bin/ci

CI.run do
  step 'Setup', 'bin/setup --skip-server'

  step 'Style: Ruby', 'bundle exec rubocop'

  step 'Security: Gem audit', 'bin/bundler-audit'
  step 'Security: Importmap vulnerability audit', 'bin/importmap audit'
  step 'Security: Brakeman code analysis', 'bundle exec brakeman --quiet --no-pager --exit-on-warn --exit-on-error'

  step 'Database: Database Consistency', 'bundle exec database_consistency'

  # step "Code: Reek", "bundle exec reek"

  step 'Test: Prepare test database', 'RAILS_ENV=test bin/rails db:test:prepare'
  step 'Test: RSpec',
       'RAILS_ENV=test CI=1 COVERAGE=1 RUBY_DEBUG_OPEN=false bundle exec rspec --format progress'

  # Optional: set a green GitHub commit status to unblock PR merge.
  # Requires the `gh` CLI and `gh extension install basecamp/gh-signoff`.
  # if success?
  #   step "Signoff: All systems go. Ready for merge and deploy.", "gh signoff"
  # else
  #   failure "Signoff: CI failed. Do not merge or deploy.", "Fix the issues and try again."
  # end
end
