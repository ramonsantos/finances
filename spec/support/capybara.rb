# frozen_string_literal: true

Capybara.default_max_wait_time = 5

Capybara.register_driver(:rack_test) do |app|
  Capybara::RackTest::Driver.new(app, respect_data_confirm: false)
end
