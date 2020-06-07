# frozen_string_literal: true

require 'rails_helper'

feature 'SignUp', type: :feature do
  feature 'sign up' do
    before { visit(new_user_registration_path) }

    scenario 'user visits registration page' do
      expect(page).to have_selector(:link_or_button, 'Finanças')
      expect(page).not_to have_selector(:link_or_button, 'Sair')

      expect(page).to have_selector('h2', text: 'Cadastro')
      expect(page).to have_selector('input', id: 'user_email')
      expect(page).to have_selector('input', id: 'user_password')
      expect(page).to have_selector('em', text: '(no mínimo 6 caracteres)')
      expect(page).to have_selector('input', id: 'user_password_confirmation')
      expect(page).to have_selector('input', id: 'user_places_name')
      expect(page).to have_selector(:link_or_button, 'Cadastrar')

      expect(page).to have_selector(:link_or_button, 'Entrar')
    end

    scenario 'user create account' do
      fill_in('user_email',                 with: 'luciano@gmail.com')
      fill_in('user_password',              with: '123456')
      fill_in('user_password_confirmation', with: '123456')
      fill_in('user_places_name',           with: 'Caruaru')

      expect { find('input[name="commit"]').click }.to change(User, :count).by(1)
      expect(page).to have_selector(:link_or_button, 'Sair')
    end

    scenario 'user tries to create account with invalid data' do
      fill_in('user_email',                 with: 'luciano@gmail.com')
      fill_in('user_password',              with: '123456')
      fill_in('user_password_confirmation', with: '123456')
      fill_in('user_places_name',           with: '')

      expect { find('input[name="commit"]').click }.not_to change(User, :count)
      expect(page).to have_selector('div', text: 'não pode ficar vazio')
      expect(page).not_to have_selector(:link_or_button, 'Sair')
    end
  end
end
