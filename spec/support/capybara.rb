# frozen_string_literal: true

Capybara.default_max_wait_time = 5

Capybara.register_driver(:rack_test) do |app|
  Capybara::RackTest::Driver.new(app, respect_data_confirm: false)
end

module ConfirmDeleteHelpers
  def confirm_destroy_from_modal
    find('label', text: 'Excluir', match: :first).click
    within('[role=alertdialog]') do
      click_button('Confirmar exclusão')
    end
  end
end

module ModalHelpers
  def within_dialog(title_element_id, &)
    dialog = find(:xpath, "//*[@id='#{title_element_id}']/ancestor::*[@role='dialog'][1]")
    within(dialog, &)
  end
end

RSpec.configure do |config|
  config.include ConfirmDeleteHelpers, type: :system
  config.include ModalHelpers, type: :system
end
