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

    context 'with one place' do
      before do
        create(:place)
        visit(places_path)
      end

      scenario 'user visits places page' do
        expect(page).to have_selector('h1', text: 'Locais')
        expect(page).to have_selector('th', text: 'Local')
        expect(page).to have_selector('td', text: 'Recife')
        expect(page).not_to have_selector(:link_or_button, 'Remover')
      end
    end

    context 'with many places' do
      before do
        create(:place)
        create(:place, name: 'Garanhuns')
        visit(places_path)
      end

      scenario 'user visits places page' do
        expect(page).to have_selector('h1', text: 'Locais')
        expect(page).to have_selector('th', text: 'Local')
        expect(page).to have_selector('td', text: 'Recife')
        expect(page).to have_selector(:link_or_button, 'Remover')
      end
    end

    context 'with one place associated to an expense' do
      let!(:place) { create(:place, name: 'Garanhuns') }

      before do
        create(:place)
        create(:expense, place_id: place.id)
        visit(places_path)
      end

      scenario 'user visits places page' do
        expect(page).to have_selector('h1', text: 'Locais')
        expect(page).to have_selector('th', text: 'Local')
        expect(page).to have_selector('td', text: 'Recife')
        expect(find(:xpath, '/html/body/main/section/div/table/tbody/tr[1]/td[2]').text).to be_blank
        expect(find(:xpath, '/html/body/main/section/div/table/tbody/tr[2]/td[2]').text).to eq('Remover')
      end
    end
  end

  feature 'create place' do
    let(:new_place_id) { Place.find_by(name: 'Garanhuns').id }

    before do
      create(:place)
      visit(places_path)
    end

    scenario 'user creates place' do
      expect(page).not_to have_selector(:link_or_button, 'Remover')
      fill_in('place_name', with: 'Garanhuns')
      click_on('Salvar')
      expect(page).to have_selector('div', text: 'Local adicionado.')
      expect(page).to have_selector('td', text: 'Garanhuns')
      expect(find(:xpath, "//a[@href='/places/#{new_place_id}']").text).to eq('Remover')
    end
  end

  feature 'remove place' do
    let!(:place) { create(:place) }

    before { create(:place_surubim) }

    scenario 'user remove one place' do
      expect do
        visit(places_path)
        expect(page).to have_selector(:link_or_button, 'Remover')
        find(:xpath, "//a[@href='/places/#{place.id}']").click
        expect(page).to have_selector('div', text: 'Local removido.')
        expect(page).to have_selector('h1', text: 'Locais')
        expect(page).to have_selector('th', text: 'Local')
        expect(page).to have_selector('td', text: 'Surubim')
        expect(page).not_to have_selector('td', text: 'Recife')
        expect(page).to have_selector('input', id: 'place_name', text: '')
        expect(page).not_to have_selector(:link_or_button, 'Remover')
      end.to change(Place, :count).by(-1)
    end
  end
end
