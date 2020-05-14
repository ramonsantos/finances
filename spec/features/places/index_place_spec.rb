# frozen_string_literal: true

require 'rails_helper'

feature 'Places', type: :feature do
  let!(:user) { create(:user) }

  before do
    create(:place)
    login_as(user)
  end

  feature 'list places' do
    context 'with one place' do
      before { visit(places_path) }

      scenario 'user visits places page' do
        expect(page).to have_selector('h1', text: 'Locais')
        expect(page).to have_selector('th', text: 'Local')
        expect(page).to have_selector('td', text: 'Recife')
        expect(page).not_to have_selector(:link_or_button, 'Remover')
      end
    end

    context 'with many places' do
      before do
        create(:place_surubim)
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
      let!(:place) { create(:place_surubim) }

      before do
        create(:expense, place_id: place.id)
        visit(places_path)
      end

      scenario 'user visits places page' do
        expect(page).to have_selector('h1', text: 'Locais')
        expect(page).to have_selector('th', text: 'Local')
        expect(page).to have_selector('td', text: 'Recife')
        expect(find(:xpath, '/html/body/main/section/div/table/tbody/tr[1]/td[2]').text).to eq('Remover')
        expect(find(:xpath, '/html/body/main/section/div/table/tbody/tr[2]/td[2]').text).to be_blank
      end
    end
  end

  feature 'create place' do
    let(:new_place_id) { Place.find_by(name: 'Garanhuns').id }

    before { visit(places_path) }

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
    let!(:place) { create(:place_surubim) }

    before { visit(places_path) }

    scenario 'user remove one place' do
      expect do
        expect(page).to have_selector(:link_or_button, 'Remover')
        find(:xpath, "//a[@href='/places/#{place.id}']").click
        expect(page).to have_selector('div', text: 'Local removido.')
        expect(page).to have_selector('h1', text: 'Locais')
        expect(page).to have_selector('th', text: 'Local')
        expect(page).to have_selector('td', text: 'Recife')
        expect(page).not_to have_selector('td', text: 'Surubim')
        expect(page).to have_selector('input', id: 'place_name', text: '')
        expect(page).not_to have_selector(:link_or_button, 'Remover')
      end.to change(Place, :count).by(-1)
    end
  end
end
