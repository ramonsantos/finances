# frozen_string_literal: true

require 'rails_helper'

feature 'LogOut', type: :feature do
  feature 'log out' do
    let!(:user) { create(:user) }

    before do
      login_as(user)
      visit(root_path)
    end

    scenario 'user log out' do
      click_on('Sair')
      expect(page).not_to have_selector(:link_or_button, 'Sair')
      expect(page).to have_selector('h2', text: 'Entrar')
    end
  end
end
