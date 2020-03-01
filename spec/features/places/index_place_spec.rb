# frozen_string_literal: true

require 'rails_helper'

feature 'Places', type: :feature do
  let!(:user) { create(:user) }

  before { login_as(user) }

  feature 'list places' do
    context 'without places ' do
      scenario 'user visits places page' do
        visit(places_path)

        expect(page).to have_selector('h1', text: 'Adicionar Local')
        expect(page).to have_selector(:link_or_button, 'Salvar')
        expect(page).to have_selector('input', id: 'place_name', text: '')
      end
    end

    context 'with places ' do
      before do
        create(:place)
        visit(places_path)
      end

      scenario 'user visits places page' do
        expect(page).to have_selector('h1', text: 'Locais')
        expect(page).to have_selector('th', text: 'Local')
        expect(page).to have_selector('td', text: 'Recife')
        expect(page).to have_selector(:link_or_button, 'Remover')
      end
    end
  end

  feature 'create place' do
    let(:new_place_id) { Place.find_by(name: 'Garanhuns').id }

    scenario 'user creates place' do
      visit(places_path)
      fill_in('place_name', with: 'Garanhuns')
      click_on('Salvar')

      expect(page).to have_selector('div', text: 'Local adicionado.')
      expect(page).to have_selector('td', text: 'Garanhuns')
      expect(find(:xpath, "//a[@href='/places/#{new_place_id}']").text).to eq('Remover')
    end
  end

  feature 'remove place' do
    let!(:place) { create(:place) }

    context 'when one place' do
      scenario 'user remove one place' do
        expect do
          visit(places_path)
          find(:xpath, "//a[@href='/places/#{place.id}']").click

          expect(page).to have_selector('div', text: 'Local removido.')
          expect(page).not_to have_selector('h1', text: 'Locais')
          expect(page).not_to have_selector('th', text: 'Local')
          expect(page).not_to have_selector('td', text: 'Recife')
          expect(page).to have_selector('input', id: 'place_name', text: '')
        end.to change(Place, :count).by(-1)
      end
    end

    context 'when many places' do
      before { create(:place_surubim) }

      scenario 'user remove one place' do
        expect do
          visit(places_path)
          find(:xpath, "//a[@href='/places/#{place.id}']").click

          expect(page).to have_selector('div', text: 'Local removido.')
          expect(page).to have_selector('h1', text: 'Locais')
          expect(page).to have_selector('th', text: 'Local')
          expect(page).to have_selector('td', text: 'Surubim')
          expect(page).not_to have_selector('td', text: 'Recife')
          expect(page).to have_selector('input', id: 'place_name', text: '')
        end.to change(Place, :count).by(-1)
      end
    end

    context 'when place with expenses' do
      before { create(:expense, place_id: place.id) }

      scenario 'user remove one place' do
        expect do
          visit(places_path)
          find(:xpath, "//a[@href='/places/#{place.id}']").click

          expect(page).to have_selector('div', text: 'Ocorreu um erro ao remover o local.')
          expect(page).to have_selector('h1', text: 'Locais')
          expect(page).to have_selector('th', text: 'Local')
          expect(page).to have_selector('td', text: 'Recife')
          expect(page).to have_selector('input', id: 'place_name', text: '')
        end.not_to change(Place, :count)
      end
    end
  end
end
