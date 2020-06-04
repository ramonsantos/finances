# frozen_string_literal: true

require 'rails_helper'

feature 'LogIn', type: :feature do
  feature 'log in' do
    before do
      create(:user)
      visit(new_user_session_path)
    end

    scenario 'user visits registration page' do
      expect(page).to have_selector(:link_or_button, 'Finanças')
      expect(page).not_to have_selector(:link_or_button, 'Sair')

      expect(page).to have_selector('h2', text: 'Entrar')
      expect(page).to have_selector('input', id: 'user_email')
      expect(page).to have_selector('input', id: 'user_password')
      expect(page).to have_selector(:link_or_button, 'Entrar')

      expect(page).to have_selector(:link_or_button, 'Criar uma conta')
    end

    scenario 'user log in' do
      fill_in('user_email',    with: 'user.user@gmail.com')
      fill_in('user_password', with: '123456')
      find('input[name="commit"]').click

      expect(page).to have_selector(:link_or_button, 'Sair')
    end
  end
end
